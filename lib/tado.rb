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
            puts response
            response['access_token']
        end
    end
end