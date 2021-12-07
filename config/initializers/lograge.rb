require 'lograge/sql/extension'

Rails.application.configure do
  # Lograge config
  config.lograge.enabled = true
  config.lograge.base_controller_class = 'ActionController::API'
  config.lograge.formatter = Lograge::Formatters::Json.new

  #   config.colorize_logging = true

  config.lograge.custom_options =
    lambda { |event| { params: event.payload[:params] } }
end
