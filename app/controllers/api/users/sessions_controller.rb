module Api
  module Users
    class SessionsController < Devise::SessionsController
      protect_from_forgery with: :null_session
      respond_to :json
      
      def create
        user = User.find_by(email: sign_in_params[:email])
        
        if user&.valid_password?(sign_in_params[:password])
          sign_in(user)
          token = generate_jwt_token(user)
          render json: {
            status: { code: 200, message: 'Logged in successfully.' },
            data: { user: { email: user.email } }
          }, status: :ok
        else
          render json: {
            status: { code: 401, message: 'Invalid email or password.' }
          }, status: :unauthorized
        end
      end

      def destroy
        sign_out(current_user)
        render json: {
          status: { code: 200, message: 'Logged out successfully.' }
        }, status: :ok
      end

      private

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end

      def generate_jwt_token(user)
        payload = { sub: user.id, exp: 24.hours.from_now.to_i }
        token = JWT.encode(payload, Rails.application.credentials.secret_key_base)
        response.headers['Authorization'] = "Bearer #{token}"
        token
      end

      def respond_to_on_destroy
        head :no_content
      end
    end
  end
end 