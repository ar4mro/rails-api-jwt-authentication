module ExceptionHandler
  extend ActiveSupport::Concern

  # Custom exception subclasses - rescue catches 'StandardErrors'
  class AuthenticationError < StandardError
  end

  class MissingToken < StandardError
  end

  class InvalidToken < StandardError
  end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ActiveRecord::RecordNotFound, with: :four_zero_four
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError,
                with: :unauthorized_request
  end

  private

  # JSON response with message; Status code 401 - unauthorized
  def unauthorized_request(exception)
    json_response({ message: exception.message }, :unauthorized)
  end

  # JSON response with message; Status code 404 - not found
  def four_zero_four(exception)
    json_response({ message: exception.message }, :not_found)
  end

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(exception)
    json_response({ message: exception.message }, :unprocessable_entity)
  end
end
