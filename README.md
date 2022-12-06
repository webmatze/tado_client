# Tado API client

a Ruby client for the tado thermostat API

## Current and Planned Features

- [ ] OAuth Authentification
- [ ] Get/Set temperature of a room

## Installation

Bundler

```ruby
# add to your Gemfile
gem 'tado_client'
```

as Gem:

```bash
gem install tado_client
```

## Usage (WIP)

Get an access token:

```ruby
access_token = Tado::OAuth.access_token(
    username: 'username', 
    password: '<password>', 
    client_id: 'client-id', 
    client_secret: '<secret>'
)
```

Set temperature for a home zone:

```ruby
require 'tado_client'

# Replace with your tado access token
access_token = 'your_access_token'

# Replace with your desired temperature
target_temperature = 21.5

# Create a new Tado::Client
client = Tado::Client.new(access_token: access_token)

# Get the user's data
me_data = client.me

# Get the first home and zone
home = me_data.homes.first
zone = home.zones.first

# Set the target temperature for the zone
zone.set_temperature(target_temperature)

```

This API will change while developing this gem.
