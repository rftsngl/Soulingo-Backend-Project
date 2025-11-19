module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_request, only: [:register, :login]

      # POST /v1/auth/register
      def register
        user = User.new(user_params)
        
        if user.save
          token = JwtService.token_for(user)
          render json: {
            data: UserSerializer.new(user).as_json,
            token: token
          }, status: :created
        else
          render json: {
            error: {
              code: 'validation_error',
              message: 'Given data is invalid',
              details: user.errors.as_json
            }
          }, status: :unprocessable_entity
        end
      end

      # POST /v1/auth/login
      def login
        user = User.find_by(email: login_params[:email])
        
        if user&.authenticate(login_params[:password])
          token = JwtService.token_for(user)
          render json: {
            data: UserSerializer.new(user).as_json,
            token: token
          }, status: :ok
        else
          render json: {
            error: {
              code: 'authentication_failed',
              message: 'Invalid email or password'
            }
          }, status: :unauthorized
        end
      end

      # GET /v1/auth/me
      def me
        render json: {
          data: UserSerializer.new(current_user).as_json
        }, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :name)
      end

      def login_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end

