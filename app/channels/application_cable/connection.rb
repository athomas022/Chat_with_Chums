module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    # def find_verified_user
    #   user_id = session[:current_user_id]
    #   User.find_by(id: user_id) if user_id
    # end
    def find_verified_user
      token = request.params[:token]
      secret_key = ENV['DEVISE_JWT_SECRET_KEY']
      begin
        decoded_token = JWT.decode(token, secret_key, true, { algorithm: 'HS256' })
        user_id = decoded_token[0]['sub']
        if verified_user = User.find_by(id: user_id)
          verified_user
        else
          reject_unauthorized_connection
        end
      rescue JWT::DecodeError
        reject_unauthorized_connection
      end
    end
      
      #   def decode_jwt(token)
      #     begin
      #       JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'], true, algorithm: 'HS256').first
      #     rescue JWT::DecodeError
      #       nil
      #     end
      #   end
      # end
  end
end

