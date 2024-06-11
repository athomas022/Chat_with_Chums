class ApplicationController < ActionController::Base
  
  # respond_to :json

  before_action :process_token
  before_action :authenticate_user!
      
    def authenticate_user!
      unless user_signed_in?
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
          puts "Session JWT Token: #{session[:jwt_token]}"
          jwt_payload = JWT.decode(session[:jwt_token], ENV['DEVISE_JWT_SECRET_KEY']).first
          puts "JWT Payload: #{jwt_payload}"
          @current_user_id = jwt_payload['id']
          puts "@current_user_id: #{@current_user_id}"
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => e
          puts "JWT Token: #{session[:jwt_token]}"
          puts "JWT Error: #{e.message}"
          session[:jwt_token] = nil
          redirect_to new_user_path, alert: "Invalid or expired token"
        end
      end
    end
end
