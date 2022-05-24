require 'rails_helper'
require 'json_web_token'
require 'faker'

describe 'POST /users' do
  let!(:user) {
    # create test user
    user = User.create({
      username: Time.now, 
      password: 'password'
    })
  }

  # test authenticated route
  context 'authenticated user' do
    it 'should return a a 201 Created status appropriate json keys when token provided and keys correct' do
      token = JsonWebToken.encode(user_id: user.id)
    end
    it 'should return a 400 Bad Request status when authorized but with bad keys' do
    end
  end

  context 'unauthenticated user' do
    # NOTE: For ease of testing this API, the route for creating new users is open
    # Depending on the security requirements a separate route for registration or 
    # an invitation system could be used instead.
    it 'should return 201 Created status when sending correct user attributes with unauthenticated route' do
    end
    it 'should return 401 Unauthorized status when sending incorrect user attributes with unauthenticated route' do
    end
  end
end
