class DirectMessagesController < ApplicationController
    def new
        recipient = User.find(params[:recipient_id])
        Rails.logger.info "Current user: #{current_user.inspect}"
        Rails.logger.info "Recipient: #{recipient.inspect}"
    
        chat_room = ChatRoom.exists_between(current_user, recipient, true) || ChatRoom.create(direct_message: true, users: [current_user, recipient])
    
        Rails.logger.info "Chat room found or created: #{chat_room.inspect}"
    
        if chat_room.persisted?
          message = Message.create(chat_room_id: chat_room.id, body: params[:body], user_id: current_user.id)
          
          if message.persisted?
            broadcast_message(chat_room, message)
            flash[:notice] = "Message sent successfully."
          else
            flash[:alert] = "Message could not be created."
          end
    
          redirect_to chat_with_path(recipient_id: recipient.id)
        else
          flash[:alert] = "Chat room could not be created."
          redirect_to root_path
        end
      end
    
      def show
        @recipient = User.find(params[:recipient_id])
        @chat_room = ChatRoom.exists_between(current_user, @recipient, true)
    
        Rails.logger.info "Chat room found for show: #{@chat_room.inspect}"
    
        if @chat_room.nil?
          @chat_room = ChatRoom.create(direct_message: true, users: [current_user, @recipient])
          Rails.logger.info "New chat room created: #{@chat_room.inspect}"
    
          if @chat_room.persisted?
            flash[:notice] = "New chat room created."
          else
            flash[:alert] = "Chat room could not be created."
            redirect_to root_path and return
          end
        end
    
        @messages = @chat_room.messages.order(created_at: :asc)
      end


    private
  
    def broadcast_message(chat_room, message)
      username = message.user.name if message.user
      ActionCable.server.broadcast("chat_room_#{chat_room.id}", {
        id: message.id,
        body: message.body,
        user_id: message.user_id,
        username: username,
        message_html: render_message(message)
      })
    end
  
    def render_message(message)
      ApplicationController.render(partial: 'messages/message', locals: { message: message })
    end
  end