module Api
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!
    before_action :authenticate_api_user!
    respond_to :json

    private

    def authenticate_api_user!
      if request.headers['Authorization'].present?
        begin
          token = request.headers['Authorization'].split(' ').last
          payload = Warden::JWTAuth::TokenDecoder.new.call(token)
          @current_user = User.find(payload['sub'])
        rescue JWT::DecodeError => e
          render_error('Invalid token', status: :unauthorized)
          return
        rescue ActiveRecord::RecordNotFound => e
          render_error('User not found', status: :unauthorized)
          return
        rescue StandardError => e
          render_error('Authentication failed', status: :unauthorized)
          return
        end
      else
        @current_user = current_user
      end

      unless @current_user
        render_error('You need to sign in or sign up before continuing.', status: :unauthorized)
      end
    end

    def current_user
      @current_user || super
    end

    def render_success(data = {}, status: :ok)
      render json: { data: data }, status: status
    end

    def render_error(messages, status: :unprocessable_entity)
      render json: { errors: Array(messages) }, status: status
    end
  end
end 