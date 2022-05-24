require 'rails_helper'
require 'json_web_token'
require 'faker'

describe 'PUT /users' do 
  # create test user 
  let!(:user) {
    user = User.create({
      username: SecureRandom.uuid, 
      password: 'password'
    })
  }

  # test authenticated route
  context 'authenticated user' do
    it 'should return a 200 OK status and expected updated json keys when token provided and keys correct' do
      token = JsonWebToken.encode(username: user.username)
      new_username = SecureRandom.uuid
      # send put request to /users
      put '/users/' + user.id.to_s(), 
        params: {
          username: new_username,
          password: 'password'
        }, 
        headers: {
          Authorization: token 
        }
      # expect HTTP Status 200 OK
      expect(response.status).to eq(200)
      # compare individual response keys to User model
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:username]).to eq(new_username)
    end

    it 'should return a 200 OK status with unchanged json keys when authorized but with bad keys' do
      token = JsonWebToken.encode(username: user.username)
      put '/users/' + user.id.to_s(), 
        params: {
          wrong_key: 'data that should not be put',
          password: 'password'
        },
        headers: {
          Authorization: token
        }
      # expect HTTP status code 200 OK
      expect(response.status).to eq(200)
      # compare individual response keys to User model
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:username]).to eq(user.username)
      # json should not have the new key
      expect(!json.has_key?(:wrong_key))
    end
  end
  
  # test unauthenticated route
  context 'unauthenticated user' do
    it 'should return status 401 Unauthorized when sending correct user attributes with unauthenticated route' do
      new_username = SecureRandom.uuid
      put '/users/' + user.id.to_s(),
        params: {
          username: new_username
        }
      # expect HTTP status code 401 Unauthorized
      expect(response.status).to eq(401)
    end
    it 'should return status 401 Unauthorized when sending incorrect user attributes with unauthenticated route' do
      put '/users/' + user.id.to_s(),
        params: {
          wrong_key: 'data that should not be put'
        }
      # expect HTTP status code 401 Unauthorized
      expect(response.status).to eq(401)
    end
  end
end
