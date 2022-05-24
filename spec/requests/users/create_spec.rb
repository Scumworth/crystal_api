require 'rails_helper'
require 'json_web_token'
require 'faker'

describe 'POST /users' do
  # create test user
  let!(:user) {
    user = User.create({
      username: SecureRandom.uuid, 
      password: 'password'
    })
  }

  # test authenticated route
  context 'authenticated user' do
    it 'should return a a 201 Created status appropriate json keys when token provided and keys correct' do
      token = JsonWebToken.encode(username: user.username)
      # create test attributes
      username = SecureRandom.uuid
      # send post request to /users
      post '/users',
        params: {
          username: username,
          password: 'password'
        },
        headers: {
          authorization: token
        }
      # expect HTTP Status 201 Created
      expect(response.status).to eq(201)
      # compare individual response keys to Profile model
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:username]).to eq(username)
    end
    it 'should return a 400 Bad Request status when authorized but with bad keys' do
      token = JsonWebToken.encode(username: user.username)
      post '/users',
        params: {
          wrong_key: 'data that should not be posted'
        },
        headers: {
          authorization: token
        }
      # expect HTTP Status 400 Bad Request
      expect(response.status).to eq(400)
    end
  end

  context 'unauthenticated user' do
    # NOTE: For ease of testing this API, the route for creating new users is open
    # Depending on the security requirements a separate route for registration or 
    # an invitation system could be used instead.
    it 'should return 201 Created status when sending correct user attributes with unauthenticated route' do
      # create test attributes
      username = SecureRandom.uuid
      # send post request to /users
      post '/users',
        params: {
          username: username,
          password: 'password'
        }
      # expect HTTP Status 201 Created
      expect(response.status).to eq(201)
      # compare individual response keys to Profile model
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:username]).to eq(username)
    end
    it 'should return 400 Bad Request status when sending incorrect user attributes with unauthenticated route' do
      post '/users',
        params: {
          wrong_key: 'data that should not be posted'
        }
      # expect HTTP Status 400 Unauthorized
      expect(response.status).to eq(400)
    end
  end
end
