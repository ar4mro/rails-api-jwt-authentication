require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => token_generator(user.id) } }

  subject(:request) { described_class.new(header) }
  subject(:invalid_request) { described_class.new({}) }

  # Test Suite for AuthorizeApiRequest#call, entry point into the service class
  describe '#call' do
    # Returns user object when request is valid
    context 'when valid request' do
      it 'returns user object' do
        result = request.call
        expect(result[:user]).to eq(user)
      end
    end

    # Returns error message when invalid request
    context 'when invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken error' do
          expect { invalid_request.call }.to raise_error(
            ExceptionHandler::MissingToken,
            'Missing token'
          )
        end
      end

      context 'when invalid token' do
        let(:header) { { 'Authorization' => token_generator(5) } }
        subject(:invalid_request) { described_class.new(header) }

        it 'raises an InvalidToken error' do
          expect { invalid_request.call }.to raise_error(
            ExceptionHandler::InvalidToken,
            /Invalid token/
          )
        end
      end

      context 'when token is expired' do
        let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
        subject(:request) { described_class.new(header) }

        it 'raises an ExpiredSignature error' do
          expect { request.call }.to raise_error(
            ExceptionHandler::InvalidToken,
            /Signature has expired/
          )
        end
      end
    end

    context 'when fake token' do
      let(:header) { { 'Authorization' => 'foobar' } }
      subject(:invalid_request) { described_class.new(header) }

      it 'raises a JWT:DecodeError eror' do
        expect { invalid_request.call }.to raise_error(
          ExceptionHandler::InvalidToken,
          /Not enough or too many segments/
        )
      end
    end
  end
end
