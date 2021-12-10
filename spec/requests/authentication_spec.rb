require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /auth/login' do
    let!(:user) { create(:user) }
    let(:headers) { valid_headers.except('Authorization') }
    let(:valid_credentials) { { email: user.email, password: user.password } }
    let(:invalid_credentials) do
      { email: Faker::Internet.email, password: Faker::Internet.password }
    end

    # Returns auth token when request is valid
    context 'when request is valid' do
      before do
        post '/auth/login', params: valid_credentials.to_json, headers: headers
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    # Returns failure message when request is invalid
    context 'When request is invalid' do
      before do
        post '/auth/login',
             params: invalid_credentials.to_json,
             headers: headers
      end

      it 'retuns a failure message' do
        expect(json['message']).to match(/Invalid credentials/)
      end
    end
  end
end
