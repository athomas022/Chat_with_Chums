class ApplicationController < ActionController::Base
  before_action :process_token

  before_action :authenticate_user!
      
    def authenticate_user!
      unless user_signed_in?
        Rails.logger.debug "User not signed in, redirecting to login path"
        redirect_to login_path
      else 
        Rails.logger.debug "User signed in: #{current_user.inspect}"  
      end
    end

    def signed_in?
        @current_user_id.present?
    end
    
    def current_user
      begin
        @current_user ||= User.find(@current_user_id) if @current_user_id.present?
      rescue ActiveRecord::RecordNotFound
        reset_session
        @current_user = nil
      end
    end

    helper_method :current_user, :user_signed_in?

    private

      def process_token
        if cookies.signed[:jwt_token].present?
          begin
            jwt_payload = JWT.decode(cookies.signed[:jwt_token], ENV['DEVISE_JWT_SECRET_KEY'], true, { algorithm: 'HS256' }).first
            @current_user_id = jwt_payload['id']
            Rails.logger.debug "JWT Payload: #{jwt_payload}"
            Rails.logger.debug "@current_user_id: #{@current_user_id}"
          rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => e
            cookies.delete(:jwt_token)
            Rails.logger.debug "JWT Error: #{e.message}"
            redirect_to new_user_path, alert: "Invalid or expired token"
          end
        end

    end
end
