class DirectMessagesController < ApplicationController
    def create
        receipient = User.find(params[:user_id])
        chat_room = ChatRoom.room_exists(receipient, current_user) || ChatRoom.dm_exist_between(receipient, current_user) || ChatRoom.create(direct_message: true, users_id: [current_user.id, receipient.id])
        message = Message.create_messages(chat_room_id: chat_room.id, body: params[:body], user_id: current_user.id)
        broadcast_message(chat_room, message)
    end
    
end
