module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      user_id = session[:current_user_id]
      User.find_by(id: user_id) if user_id
    end
      # def find_verified_user
      #   token = request.headers[:HTTP_AUTHORIZATION]
      #   if token.present?
      #     decoded_token = decode_jwt(token)
      #     if decoded_token && (user_id = decoded_token["id"])
      #       return User.find_by(id: user_id)
      #     end
      #   else
      #     reject_unauthorized_connection
      #   end
      # end
      
      #   def decode_jwt(token)
      #     begin
      #       JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'], true, algorithm: 'HS256').first
      #     rescue JWT::DecodeError
      #       nil
      #     end
      #   end
      # end
  end

