require 'rails_helper'
require 'json_web_token'
require 'faker'

describe 'DELETE /profiles' do
  # create test user 
  let!(:user) {
    @user = User.create({
      username: Faker::Lorem.word, 
      password: 'password'
    })
  }

  # create test team
  let!(:team) {
    @team = Team.create({
      name: Faker::Lorem.word
    })
  }

  # create test profile 
  let!(:profile) {
    @profile = Profile.create({
      first_name: Faker::Name.first_name, 
      last_name: Faker::Name.last_name, 
      email: Faker::Internet.email, 
      team_id: @team.id
    })
    # add new profile to database
    @profile.save
  }

  # retrieve authentication token for created user
  let!(:token) {
    @token = JsonWebToken.encode(user_id: @user.id)
  }

  # test authenticated route
  context 'authenticated user' do
    it 'should return a 204 No Content status' do
      delete '/profiles/' + @profile.id.to_s(), headers: { Authorization: @token }
      # expect HTTP status code 204 No Content
      expect(response.status).to eq(204)
    end
  end

  # test unauthenticated route
  context 'unauthenticated user' do
    it 'should return a 401 Unauthorized status' do
      delete '/profiles/' + @profile.id.to_s()
      # expect HTTP status code 401 Unauthorized
      expect(response.status).to eq(401)
    end
  end
end

