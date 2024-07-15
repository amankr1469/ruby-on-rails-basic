# module V1
#   class AuthAPI < Grape::API
#     version 'v1', using: :path
#     format :json
#     helpers AuthHelpers
#     resource :auth do
#       desc 'User authentication'
#       params do
#         requires :email, type: String, desc: 'User email'
#         requires :password, type: String, desc: 'User password'
#       end

#       post :login do
#         user = User.find_by(email: params[:email])
#         # if user && user.authenticate(params[:password])
#         #   token = JsonWebToken.encode(user_id: user.id)
#         #   { token: token }
#         # else 
#         #   error!('Invalid email or password', 401)
#         # end
#         authenticated_user = user&.authenticate(params[:password])
 
#         if authenticated_user
#           token = JsonWebToken.encode(user_id: user.id)
#           expires_at = JsonWebToken.decode(token)[:exp]
 
#           render json: { token: token, expires_at: expires_at}, status: :ok
#         else
#           render json: { error: 'unauthorized' }, status: :unauthorized
#         end
#       end

#       desc 'User registration'
#       params do
#         requires :email, type: String, desc: 'User email'
#         requires :password, type: String, desc: 'User password'

#       end

#       post :register do
#         user = User.new(
#           email: params[:email],
#           password: params[:password],
#           password_confirmation: params[:password]
#         )

#         if user.save
#           {message: 'User Created'}
#         else 
#           error!('Invalid input', 422)
#         end
#       end
#     end
#   end
# end

module V1
  class AuthAPI < Grape::API
    version 'v1', using: :path
    format :json
    helpers AuthHelpers
    include JsonWebToken

    resource :auth do
      desc 'Authenticate and get a token'
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
      end
      post :login do
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          { token: token }
        else
          error!('Unauthorized', 401)
        end
      end

      desc 'Register a new user'
      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
        requires :password_confirmation, type: String, desc: 'Password confirmation'
      end
      post :register do
        user = User.new(
          email: params[:email],
          password: params[:password],
          password_confirmation: params[:password_confirmation]
        )
        if user.save
          { message: 'User created successfully' }
        else
          error!(user.errors.full_messages, 422)
        end
      end
    end
  end
end
