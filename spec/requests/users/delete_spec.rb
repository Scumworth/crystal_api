require 'rails_helper'
require 'json_web_token'
require 'faker'

describe 'DELETE /users' do
  # create test user 
  let!(:user) {
    user = User.create({
      username: SecureRandom.uuid, 
      password: 'password'
    })
  }

  # test authenticated route
  context 'authenticated user' do
    it 'should return a 204 No Content status' do
      token = JsonWebToken.encode(username: user.username)
      delete '/users/' + user.id.to_s(), headers: { Authorization: token }
      # expect HTTP status code 204 No Content
      expect(response.status).to eq(204)
    end
  end

  # test unauthenticated route
  context 'unauthenticated user' do
    it 'should return a 401 Unauthorized status' do
      delete '/users/' + user.id.to_s()
      # expect HTTP status code 401 Unauthorized
      expect(response.status).to eq(401)
    end
  end
end
