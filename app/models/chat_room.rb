class ChatRoom < ApplicationRecord
    has_many :participants
    has_many :users, through: :participants
    belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
    has_many :messages

    validate :direct_message_limit, if: -> { direct_message? }

    def direct_message_limit
        if users_id.count != 2
            errors.add(:base, 'Direct messaging only available between 2 users')
        end
    end
    
    def self.exists_between(user1, user2, direct_message)
        Rails.logger.info "Checking chat room existence between #{user1.id} and #{user2.id} with direct_message: #{direct_message}"
        chat_room = ChatRoom.joins(:participants)
                            .where(direct_message: direct_message)
                            .where("users_id @> ARRAY[?]::integer[]", [user1.id, user2.id])
                            .group('chat_rooms.id')
                            .having('COUNT(users_id) = 2')
                            .limit(1)
                            .first
        Rails.logger.info "Chat room existence check result: #{chat_room.inspect}"
        chat_room
    end
    
    def self.search_by_keyword(keyword)
       if keyword.present?   
        ChatRoom.where("name LIKE ?", "%#{keyword}%")
       else
        ChatRoom.all
       end
    end


end
