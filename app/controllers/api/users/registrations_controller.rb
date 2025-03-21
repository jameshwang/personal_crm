module Api
  module Users
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: {
            status: { code: 200, message: 'Signed up successfully.' },
            data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
          }
        else
          render json: {
            status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
          }, status: :unprocessable_entity
        end
      end

      def respond_to_on_destroy
        if current_user
          render json: { status: 200, message: 'Account deleted successfully.' }
        else
          render json: { status: 401, message: "Couldn't find an active session." }
        end
      end
    end
  end
end 