require 'rails_helper'
require 'json_web_token'
require 'faker'

describe 'PUT /profiles' do 
  # create test user 
  let!(:user) {
    user = User.create({
      username: SecureRandom.uuid, 
      password: 'password'
    })
  }
  # create test profile 
  let!(:profile) {
    team = Team.create({
      name: Faker::Lorem.word
    })
    Profile.create({
      first_name: Faker::Name.first_name, 
      last_name: Faker::Name.last_name, 
      email: Faker::Internet.email, 
      team_id: team.id
    })
  }

      
  # test authenticated route
  context 'authenticated user' do
    it 'should return a 200 OK status and expected updated json keys when token provided and keys correct' do
      token = JsonWebToken.encode(username: user.username)
      new_first_name = Faker::Name.first_name
      new_email = Faker::Internet.email
      # send put request to /profiles
      put '/profiles/' + profile.id.to_s(), 
        params: {
          first_name: new_first_name,
          email: new_email,
        }, 
        headers: {
          Authorization: token 
        }
      # expect HTTP Status 200 OK
      expect(response.status).to eq(200)
      # compare individual response keys to Profile model
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:first_name]).to eq(new_first_name)
      expect(json[:last_name]).to eq(profile.last_name)
      expect(json[:email]).to eq(new_email)
      expect(json[:team][:id]).to eq(profile.team_id)
    end

    it 'should return a 200 OK status with unchanged json keys when authorized but with bad keys' do
      token = JsonWebToken.encode(username: user.username)
      put '/profiles/' + profile.id.to_s(), 
        params: {
          wrong_key: 'data that should not be put'
        },
        headers: {
          Authorization: token
        }
      # expect HTTP status code 200 OK
      expect(response.status).to eq(200)
      # compare individual response keys to Profile model
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:first_name]).to eq(profile.first_name)
      expect(json[:last_name]).to eq(profile.last_name)
      expect(json[:email]).to eq(profile.email)
      expect(json[:team][:id]).to eq(profile.team_id)
      # json should not have the new key
      expect(!json.has_key?(:wrong_key))
    end
  end
  
  # test unauthenticated route
  context 'unauthenticated user' do
    it 'should return status 401 Unauthorized when sending correct profile attributes with unauthenticated route' do
      new_first_name = Faker::Name.first_name
      new_email = Faker::Internet.email
      put '/profiles/' + profile.id.to_s(),
        params: {
          first_name: new_first_name,
          email: new_email
        }
      # expect HTTP status code 401 Unauthorized
      expect(response.status).to eq(401)
    end
    it 'should return status 401 Unauthorized when sending incorrect profile attributes with unauthenticated route' do
      put '/profiles/' + profile.id.to_s(),
        params: {
          wrong_key: 'data that should not be put'
        }
      # expect HTTP status code 401 Unauthorized
      expect(response.status).to eq(401)
    end
  end
end
