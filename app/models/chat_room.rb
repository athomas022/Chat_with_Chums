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
    
    def self.room_exists(sender, receipient)
        chat_room = ChatRoom.joins(:users)#brings back all the chatrooms with users
                    .where(direct_message: true) #where direct messages are true
                    .where(users: {id: sender_id, receipient_id})
                    .group(chat_room_id)
                    .having(count(chat_room_id)=2)
                    .first
    end
    
    def self.search_by_keyword(keyword)
       if keyword.present?   
        ChatRoom.where("name LIKE ?", "%#{keyword}%")
       else
        ChatRoom.all
       end
    end


end
