require 'rails_helper'

RSpec.describe JwtService do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123', name: 'Test User', role: 'student') }

  describe '.token_for' do
    it 'generates a JWT token' do
      token = JwtService.token_for(user)
      expect(token).to be_present
      expect(token).to be_a(String)
    end

    it 'includes user id in token' do
      token = JwtService.token_for(user)
      decoded = JwtService.decode(token)
      expect(decoded['sub']).to eq(user.id)
    end

    it 'includes user role in token' do
      token = JwtService.token_for(user)
      decoded = JwtService.decode(token)
      expect(decoded['role']).to eq(user.role)
    end
  end

  describe '.decode' do
    it 'decodes a valid token' do
      token = JwtService.token_for(user)
      decoded = JwtService.decode(token)
      expect(decoded).to be_present
      expect(decoded['sub']).to eq(user.id)
    end

    it 'returns nil for invalid token' do
      decoded = JwtService.decode('invalid_token')
      expect(decoded).to be_nil
    end
  end
end

