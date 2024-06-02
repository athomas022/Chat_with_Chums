class ChatRoom < ApplicationRecord
    has_many :participants
    has_many :users, through: :participants
    belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
    has_many :messages
end
