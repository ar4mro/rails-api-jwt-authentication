require 'rails_helper'

RSpec.describe AuthenticateUser do
  let(:user) { create(:user) }

  subject(:valid_auth_obj) { described_class.new(user.email, user.password) }
  subject(:invalid_auth_obj) { described_class.new('foo', 'bar') }

  # Test suite for AuthenticateUser#call
  describe '#call' do
    # Returns token when valid request
    context 'when valid credentials' do
      it 'returns auth token' do
        token = valid_auth_obj.call
        expect(token).not_to be_nil
      end
    end

    # Returns error message when invalid request
    context 'when invalid credentials' do
      it 'raises an AuthenticationError error' do
        expect { invalid_auth_obj.call }.to raise_error(
          ExceptionHandler::AuthenticationError,
          /Invalid credentials/
        )
      end
    end
  end
end
