require 'net/http'
require 'json'
require 'uri'

module Tado
    class OAuth
        def initialize(username:, password:, client_id:, client_secret:)
            @username = username
            @password = password
            @client_id = client_id
            @client_secret = client_secret
        end

        def get_token
            uri = URI('https://auth.tado.com/oauth/token')
            req = Net::HTTP::Post.new(uri)
            req.set_form_data(
                'client_id' => @client_id,
                'client_secret' => @client_secret,
                'grant_type' => 'password',
                'password' => @password,
                'scope' => 'home.user',
                'username' => @username
            )
            res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
                http.request(req)
            end
            response = JSON.parse(res.body)
            response['access_token']
        end
    end

    class Client
        def initialize(access_token:)
            @access_token = access_token
        end

        def me
            me_data = make_http_request(url: 'https://my.tado.com/api/v2/me')
            Me.new(data: me_data, client: self)
        end

        def make_http_request(url:)
            uri = URI(url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true

            req = Net::HTTP::Get.new(uri)
            req['Authorization'] = "Bearer #{@access_token}"
            req['Content-Type'] = 'application/json'

            res = http.request(req)
            JSON.parse(res.body)
        end
    end

    class Me
        attr_reader :name, :email, :username, :id

        def initialize(data:, client:)
            @data = data
            @name = data["name"]
            @email = data["email"]
            @username = data["username"]
            @id = data["id"]
            @client = client
        end

        def homes
            @data['homes']
        end

        def to_s
            "Name: #{@name}, Email: #{@email}, Username: #{@username}, ID: #{@id}, Homes: #{@homes}"
        end
    end
end