module MyGrapeAPI
  class Base < Grape::API
    format :json

    get :ping do
      { message: 'pong' }
    end

    mount V1::BlogAPI
    mount V1::AuthAPI
  end
end
