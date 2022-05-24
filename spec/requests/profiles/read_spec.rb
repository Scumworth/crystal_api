require 'rails_helper'
require 'json_web_token'
require 'faker'

describe 'GET /profiles' do
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
      name: SecureRandom.uuid
    })
    profile = Profile.create({
      first_name: Faker::Name.first_name, 
      last_name: Faker::Name.last_name, 
      email: Faker::Internet.email, 
      team_id: team.id
    })
  }

  # test authenticated route
  context 'authenticated user' do
    it 'should return a 200 OK status and all profiles with all keys' do
      token = JsonWebToken.encode(username: user.username)
      get '/profiles', headers: { Authorization: token }
      # expect HTTP status code 200 OK
      expect(response.status).to eq(200)
      # expect returned json to have same number of entries as Profiles
      expect(JSON.parse(response.body).length == Profile.all.length)
    end
    it 'should return a 200 OK status and single profile with all keys' do
      token = JsonWebToken.encode(username: user.username)
      get '/profiles/' + profile.id.to_s(), headers: { Authorization: token }
      # expect HTTP status code 200 OK
      expect(response.status).to eq(200)
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:first_name]).to eq(profile.first_name)
      expect(json[:last_name]).to eq(profile.last_name)
      expect(json[:email]).to eq(profile.email)
      expect(json[:team][:id]).to eq(profile.team_id)
    end
  end

  # test unauthenticated route
  context 'unauthenticated user' do
    it 'should return a 200 OK status and all profiles with limited keys' do
      get '/profiles'
      # expect HTTP status code 200 OK
      expect(response.status).to eq(200)
      # expect returned json to have same number of entries as Profiles
      expect(JSON.parse(response.body).length == Profile.all.length)
    end
    it 'should return a 200 OK status and a single profile with limited keys' do
      get '/profiles/' + profile.id.to_s()
      # expect HTTP status code 200 OK
      expect(response.status).to eq(200)
      # expect returned JSON keys to match searched for profile's 
      # but not included excluded keys
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:first_name]).to eq(profile.first_name)
      expect(json[:last_name]).to eq(profile.last_name)
      expect(json[:email]).to eq(nil)
      expect(json[:team]).to eq(nil)
    end
  end
end


