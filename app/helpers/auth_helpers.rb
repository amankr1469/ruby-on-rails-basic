require 'jwt'

# module JsonWebToken
#   SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

#   def self.encode(payload, exp = 24.hours.from_now)
#     payload[:exp] = exp.to_i
#     JWT.encode(payload, SECRET_KEY)
#   end

#   def self.decode(token)
#     body = JWT.decode(token, SECRET_KEY)[0]
#     HashWithIndifferentAccess.new body
#   rescue
#     nil
#   end
# end

module AuthHelpers
  # include JsonWebToken
  # def current_user
  #   @current_user ||= User.find(decode_auth_token[:user_id]) if decoded_auth_token
  # end

  # def authenticate!
  #   error!('Unauthorized', 401) unless current_user
  # end

  # private

  # def decoded_auth_token
  #   # puts "Environmetn variables #{ENV["test"]}"
  #   @decoded_auth_token = nil
  #   # @decoded_auth_token ||= 
  #   puts JsonWebToken.decode(http_token)
  # end

  # def http_token
  #   if headers['Authorization'].present?
  #     headers['Authorization'].split(' ').last
  #   end
  # end

  # def headers
  #   request.headers
  # end
  def authenticate
    authorization_header = request.headers['Authorization']
    token = authorization_header.split(" ").last if authorization_header
    decoded_token = JsonWebToken.decode(token)
 
    User.find(decoded_token[:user_id])
  end
 
  def invalid_token
    render json: { invalid_token: 'invalid token' }
  end
 
  def decode_error
    render json: { decode_error: 'decode error' }
  end
end
