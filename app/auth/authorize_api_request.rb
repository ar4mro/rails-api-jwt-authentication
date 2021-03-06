# Service, decodes token from header and returns user if valid
class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  def call
    { user: user }
  end

  private

  attr_reader :headers

  def user
    begin
      @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    rescue ActiveRecord::RecordNotFound => e
      raise(
        ExceptionHandler::InvalidToken,
        "#{Message.invalid_token} #{e.message}"
      )
    end
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end

    raise(ExceptionHandler::MissingToken, Message.missing_token)
  end
end
