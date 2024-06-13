class ApplicationCable::Connection < ActionCable::Connection::Base
  identified_by :current_user

  def connect
    self.current_user = find_verified_user
  end

  private

  def find_verified_user
    token = request.params[:token]
    secret_key = ENV['DEVISE_JWT_SECRET_KEY']
    Rails.logger.debug "Token received: #{token}"
    begin
      decoded_token = JWT.decode(token, secret_key, true, { algorithm: 'HS256' })
      Rails.logger.debug "Decoded Token: #{decoded_token}"
      user_id = decoded_token[0]['id']
      if (verified_user = User.find_by(id: user_id))
        verified_user
      else
        Rails.logger.debug "User not found with ID: #{user_id}"
        reject_unauthorized_connection
      end
    rescue JWT::DecodeError => e
      Rails.logger.debug "JWT Decode Error: #{e.message}"
      reject_unauthorized_connection
    end
  end
end

