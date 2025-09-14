require 'rails_helper'

RSpec.describe 'API Auth', type: :request do
  describe 'POST /api/v1/auth/register and /login' do
    it 'registers then logs in successfully' do
      post '/api/v1/auth/register', params: { username: 'alice', email: 'a@example.com', password: 'secret123' }
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['token']).to be_present

      post '/api/v1/auth/login', params: { username: 'alice', password: 'secret123' }
      expect(response).to have_http_status(:ok)
      json2 = JSON.parse(response.body)
      expect(json2['token']).to be_present
    end
  end
end

