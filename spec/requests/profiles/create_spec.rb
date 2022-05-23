require 'rails_helper'
require 'json_web_token'
require 'faker'

describe 'POST /profiles' do 
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
  }

  # retrieve authentication token for created user
  let!(:token) {
    @token = JsonWebToken.encode(user_id: @user.id)
  }

  # test authenticated route
  context 'authenticated user' do
    it 'should return a Created status and appropriate json keys when token provided and keys correct' do
      # send put request to /profiles/
      post '/profiles', 
        params: {
          first_name: @profile.first_name,
          last_name: @profile.last_name,
          email: @profile.email,
          team_id: @profile.team_id
        }, 
        headers: {
          Authorization: @token 
        }
      # expect HTTP Status 201 Created
      expect(response.status).to eq(201)
      # compare individual response keys to Profile model
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:first_name]).to eq(@profile.first_name)
      expect(json[:last_name]).to eq(@profile.last_name)
      expect(json[:email]).to eq(@profile.email)
      expect(json[:team][:id]).to eq(@profile.team_id)
    end

    it 'should return a Bad Request status when authorized but with bad keys' do
      post '/profiles', 
        params: {
          wrong_key: 'data that should not be posted'
        },
        headers: {
          authorization: @token
        }
      # expect HTTP status code 400 Bad Request
      expect(response.status).to eq(400)
    end
  end
  
  # test unauthenticated route
  context 'unauthenticated user' do
    it 'should return status 401 Unauthorized when sending correct profile attributes with unauthenticated route' do
      post '/profiles',
        params: {
          first_name: @profile.first_name,
          last_name: @profile.last_name,
          email: @profile.email,
          team_id: @profile.team_id
        }
      # expect HTTP status code 401 Unauthorized
      expect(response.status).to eq(401)
    end
    it 'should return status 401 Unauthorized when sending incorrect profile attributes with unauthenticated route' do
      post '/profiles',
        params: {
          wrong_key: 'data that should not be posted'
        }
      # expect HTTP status code 401 Unauthorized
      expect(response.status).to eq(401)
    end
  end
end
