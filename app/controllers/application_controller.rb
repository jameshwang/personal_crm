class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  before_action :authenticate_user!, unless: :api_request?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def api_request?
    request.path.start_with?('/api/')
  end
end
