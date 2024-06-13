class DirectMessagesController < ApplicationController
  def new
    recipient = User.find(params[:recipient_id])
   
    chat_room = ChatRoom.exists_between(current_user, recipient, true) || ChatRoom.new(direct_message: true, users_id: [current_user.id, recipient.id], admin_id: current_user.id)
    
    if chat_room.new_record?   
      if chat_room.save
        chat_room.users << [current_user, recipient]
      else
        flash[:alert] = "Chat room could not be created."
        redirect_to root_path and return
      end
    else
      Rails.logger.info "Existing chat room found: #{chat_room.inspect}"
    end
    
    message = Message.create(chat_room: chat_room, body: params[:body], user: current_user)
    if message.persisted?
      broadcast_message(chat_room, message)
      flash[:notice] = "Message sent successfully."
    else
      flash[:alert] = "Message could not be created."
    end
    
    redirect_to chat_room_direct_message_path(chat_room.id, id: chat_room.id, recipient_id: recipient.id)
  end

  def show
    @recipient = User.find(params[:recipient_id])
    @chat_room = ChatRoom.exists_between(current_user, @recipient, true)
    
    if @chat_room.nil?
      @chat_room = ChatRoom.create(direct_message: true, users_id: [current_user.id, @recipient.id], admin_id: current_user.id)
      if @chat_room.persisted?
        @chat_room.users << [current_user, @recipient]
        flash[:notice] = "New chat room created."
      else
        flash[:alert] = "Chat room could not be created."
        redirect_to root_path and return
      end
    end
    
    @messages = @chat_room.messages.includes(:user).order(created_at: :asc)
  end
  
  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    if params[:recipient_id].present?
      @recipient = User.find(params[:recipient_id])
    else
      flash[:alert] = "Recipient not specified."
      redirect_to chat_room_path(@chat_room) and return
    end

    @message = @chat_room.messages.new(message_params)
    @message.user_id = current_user.id

    if @message.save
      broadcast_message(@chat_room, @message)
      flash[:notice] = "Message sent successfully."
      redirect_to chat_room_direct_message_path(@chat_room, recipient_id: @recipient.id)
    else
      flash[:alert] = "Message could not be created."
      redirect_to chat_room_direct_message_path(@chat_room, recipient_id: @recipient.id)
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.warn("Error creating message: #{e.message}")
    flash[:alert] = "An error occurred while creating the message."
    redirect_back(fallback_location: chat_room_path(@chat_room))
  rescue StandardError => e
    Rails.logger.warn("Error creating message: #{e.message}")
    flash[:alert] = "An unexpected error occurred."
    redirect_back(fallback_location: chat_room_path(@chat_room))
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
  
  def message_params
    params.require(:message).permit(:body)
  end

  def render_message(message)
    ApplicationController.render(partial: 'messages/message', locals: { message: message })
  end
end