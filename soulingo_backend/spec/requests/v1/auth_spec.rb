require 'rails_helper'

RSpec.describe 'V1::Auth', type: :request do
  describe 'POST /v1/auth/register' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            email: 'newuser@example.com',
            password: 'password123',
            name: 'New User'
          }
        }
      end

      it 'creates a new user' do
        expect {
          post '/v1/auth/register', params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'returns 201 status' do
        post '/v1/auth/register', params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'returns user data and token' do
        post '/v1/auth/register', params: valid_params
        json = JSON.parse(response.body)
        expect(json['data']).to be_present
        expect(json['data']['type']).to eq('user')
        expect(json['data']['attributes']['email']).to eq('newuser@example.com')
        expect(json['token']).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'returns 422 status with validation errors' do
        post '/v1/auth/register', params: { user: { email: 'invalid' } }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']['code']).to eq('validation_error')
      end
    end
  end

  describe 'POST /v1/auth/login' do
    let!(:user) { User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student') }

    context 'with valid credentials' do
      it 'returns 200 status' do
        post '/v1/auth/login', params: { user: { email: 'test@example.com', password: 'password123' } }
        expect(response).to have_http_status(:ok)
      end

      it 'returns user data and token' do
        post '/v1/auth/login', params: { user: { email: 'test@example.com', password: 'password123' } }
        json = JSON.parse(response.body)
        expect(json['data']).to be_present
        expect(json['token']).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'returns 401 status' do
        post '/v1/auth/login', params: { user: { email: 'test@example.com', password: 'wrongpassword' } }
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json['error']['code']).to eq('authentication_failed')
      end
    end
  end

  describe 'GET /v1/auth/me' do
    let!(:user) { User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student') }
    let(:token) { JwtService.token_for(user) }

    context 'with valid token' do
      it 'returns 200 status' do
        get '/v1/auth/me', headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
      end

      it 'returns current user data' do
        get '/v1/auth/me', headers: { 'Authorization' => "Bearer #{token}" }
        json = JSON.parse(response.body)
        expect(json['data']['attributes']['email']).to eq('test@example.com')
      end
    end

    context 'without token' do
      it 'returns 401 status' do
        get '/v1/auth/me'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

