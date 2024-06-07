class ChatRoom < ApplicationRecord
    has_many :participants
    has_many :users, through: :participants
    belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
    has_many :messages

    validate :direct_message_limit, if: :direct_message?

    def direct_message_limit
        if users.count != 2
            errors.add(:base, 'Direct messaging only available between 2 users')
        end
    end
end
