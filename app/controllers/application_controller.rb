class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  respond_to :json

  before_action :process_token
      
    def authenticate_user!(options = {})
      unless signed_in?
        redirect_to new_user_path
      end
    end

    def signed_in?
        @current_user_id.present?
    end
    
    def current_user
        @current_user ||= User.find(@current_user_id) if @current_user_id.present?
    end

    private

    def process_token
      if session[:jwt_token].present?
        begin
          jwt_payload = JWT.decode(session[:jwt_token], ['DEVISE_JWT_SECRET_KEY']).first
          @current_user_id = jwt_payload['id']
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          session[:jwt_token] = nil
          redirect_to new_user_path, alert: "Invalid or expired token"
        end
      end
    end
end
