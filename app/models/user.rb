class User < ApplicationRecord
    devise :database_authenticatable, :registerable
    has_many :participants
    has_many :chat_rooms, through: :participants
    has_many :create_chat_rooms, class_name: 'ChatRoom', foreign_key: 'admin_id'
    
  

    def friends
        User.where(id: friends_id)
      end

    has_secure_password  
    
    def generate_jwt
        JWT.encode({ id: self.id, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
    end

end
