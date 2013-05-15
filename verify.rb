# Copyright 2013 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


##
# Simple server to demonstrate token verification.
#
# Author: cartland@google.com (Chris Cartland)
require 'rubygems'
require 'json'
require 'sinatra'
require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google-id-token'
require 'net/https'
require 'uri'
use Rack::Session::Pool, :expire_after => 86400 # 1 day

# Configuration
# See the README.md for getting the OAuth 2.0 client ID and
# client secret.

# Configuration that you probably don't have to change
APPLICATION_NAME = 'Google+ Ruby Token Verification'
set :port, 4567

# Build the global client
credentials = Google::APIClient::ClientSecrets.load
client = Google::APIClient.new


##
# Connect the user with Google+ and store the credentials.
post '/verify' do
  # Verify an ID Token or an Access Token

  id_token = params[:id_token]
  access_token = params[:access_token]

  token_status = Hash.new

  id_status = Hash.new
  if id_token
    # Check that the ID Token is valid.
    validator = GoogleIDToken::Validator.new
    client_id = credentials.client_id
    jwt = validator.check(id_token, client_id, client_id)
    if jwt
      id_status['valid'] = true
      id_status['gplus_id'] = jwt['sub']
      id_status['message'] = 'Valid ID Token.'
    else
      id_status['valid'] = false
      id_status['gplus_id'] = nil
      id_status['message'] = 'Invalid ID Token.'
    end
    token_status['id_token_status'] = id_status
  end

  access_status = {}
  if access_token
    # Check that the Access Token is valid.
    oauth2 = client.discovered_api('oauth2','v2')
    client.authorization.access_token = access_token
    tokeninfo = JSON.parse(client.execute(oauth2.tokeninfo,
        :access_token => access_token).response.body)
    puts tokeninfo
    if tokeninfo['error']
      # This is not a valid token.
      access_status['valid'] = false
      access_status['gplus_id'] = nil
      access_status['message'] = 'Invalid Access Token.'
    elsif tokeninfo['issued_to'] != credentials.client_id
      # This is not meant for this app. It is VERY important to check
      # the client ID in order to prevent man-in-the-middle attacks.
      access_status['valid'] = false
      access_status['gplus_id'] = nil
      access_status['message'] = 'Access Token not meant for this app.'
    else
      access_status['valid'] = true
      access_status['gplus_id'] = tokeninfo['user_id']
      access_status['message'] = 'Valid Access Token.'
    end
    token_status['access_token_status'] = access_status
  end

  content_type :json
  status 200
  token_status.to_json
end


##
# Fill out the templated variables in index.html.
get '/' do
  response = File.read('index.html')
  response = response.sub(/[{]{2}\s*CLIENT_ID\s*[}]{2}/, credentials.client_id)
  response = response.sub(/[{]{2}\s*APPLICATION_NAME\s*[}]{2}/, 
      APPLICATION_NAME)
end
