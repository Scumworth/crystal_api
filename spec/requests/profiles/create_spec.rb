require 'rails_helper'
require 'json_web_token'
require 'faker'

describe 'POST /profiles' do 
  # create test user
  let!(:user) {
    user = User.create({
      username: SecureRandom.uuid, 
      password: 'password'
    })
  }
  # create test team
  let!(:team) {
    team = Team.create({
      name: SecureRandom.uuid, 
    })
  }
 
  # create test attributes
  let!(:first_name) {
    first_name = Faker::Name.first_name
  }
  let!(:last_name) {
    last_name = Faker::Name.last_name
  }
  let!(:email) {
    email = Faker::Internet.email
  }
  let!(:team_id) {
    team_id = team.id
  }

  # test authenticated route
  context 'authenticated user' do
    it 'should return a 201 Created status and appropriate json keys when token provided and keys correct' do
      token = JsonWebToken.encode(username: user.username)
      # send post request to /profiles
      post '/profiles', 
        params: {
          first_name: first_name,
          last_name: last_name,
          email: email,
          team_id: team_id
        }, 
        headers: {
          Authorization: token 
        }
      # expect HTTP Status 201 Created
      expect(response.status).to eq(201)
      # compare individual response keys to Profile model
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:first_name]).to eq(first_name)
      expect(json[:last_name]).to eq(last_name)
      expect(json[:email]).to eq(email)
      expect(json[:team][:id]).to eq(team_id)
    end

    it 'should return a 400 Bad Request status when authorized but with bad keys' do
      token = JsonWebToken.encode(username: user.username)
      post '/profiles', 
        params: {
          wrong_key: 'data that should not be posted'
        },
        headers: {
          Authorization: token
        }
      # expect HTTP status code 400 Bad Request
      expect(response.status).to eq(400)
    end
  end
  
  # test unauthenticated route
  context 'unauthenticated user' do
    it 'should return 401 Unauthorized status when sending correct profile attributes with unauthenticated route' do
      post '/profiles',
        params: {
          first_name: first_name,
          last_name: last_name,
          email: email,
          team_id: team_id
        }
      # expect HTTP status code 401 Unauthorized
      expect(response.status).to eq(401)
    end
    it 'should return 401 Unauthorized status when sending incorrect profile attributes with unauthenticated route' do
      post '/profiles',
        params: {
          wrong_key: 'data that should not be posted'
        }
      # expect HTTP status code 401 Unauthorized
      expect(response.status).to eq(401)
    end
  end
end
