require 'rails_helper'
require 'json_web_token'
require 'faker'

describe 'GET /users' do
  # create test user 
  let!(:user) {
    user = User.create({
      username: SecureRandom.uuid, 
      password: 'password'
    })
  }

  # test authenticated route
  context 'authenticated user' do
    it 'should return a 200 ok status and and all users' do
      token = JsonWebToken.encode(username: user.username)
      get '/users', headers: { Authorization: token }
      # expect http status code 200 ok
      expect(response.status).to eq(200)
      # expect returned json to have same number of entries as users
      expect(JSON.parse(response.body).length == User.all.length)
    end
    it 'should return a 200 ok status and single user' do
      token = JsonWebToken.encode(username: user.username)
      get '/users/' + user.id.to_s(), headers: { authorization: token }
      # expect http status code 200 ok
      expect(response.status).to eq(200)
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:username]).to eq(user.username)
    end
  end

  # test unauthenticated route
  context 'unauthenticated user' do
    it 'should return a 401 Unauthorized status' do
      get '/users'
      # expect http status code 401 Unauthorized
      expect(response.status).to eq(401)
    end
  end
end
