class Message < ApplicationRecord
    belongs_to :user, class_name: 'User', foreign_key: 'user_id'
    belongs_to :chat_room, class_name: 'ChatRoom', foreign_key: 'chat_room_id'
end