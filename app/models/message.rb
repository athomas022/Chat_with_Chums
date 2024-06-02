class Message < ApplicationRecord
    belongs_to :user, class_name: 'User', foreign_key: 'created_by'
    belongs_to :chat_room, class_name: 'ChatRoom', foreign_key: 'chat_rooms'
end