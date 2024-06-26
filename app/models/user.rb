class User < ApplicationRecord
    has_many :participants
    has_many :chat_rooms, through: :participants
    has_many :create_chat_rooms, class_name: 'ChatRoom', foreign_key: 'admin_id'
  
    has_secure_password
  
    def friends
      User.where(id: friends_id)
    end
  
    def self.generate_jwt(username)
        user = User.find_by(username: username)
        JWT.encode({ id: user.id, exp: 60.days.from_now.to_i }, ENV['DEVISE_JWT_SECRET_KEY'], 'HS256')
    end
  
    def self.search_by_username(username)
      if username.present?
        User.where("name LIKE ?", "%#{username}%")
      else
        User.all
      end
    end
  end
  