class User < ApplicationRecord
    devise :database_authenticatable, :registerable
    has_many :participants
    has_many :chat_rooms, through: :participants
    has_many :create_chat_rooms, class_name: 'ChatRoom', foreign_key: 'admin_id'
    
end
