class MessagesController < ApplicationController
  def index
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages
    render json: @message
  rescue StandardError => e
    Logger.warn("Error fetching messages: #{e.message}")
  end

  def show
    @message = ChatRoom.where(chat_room_id: params[:chat_room_id]).find(params[:id])
    render json: @message
  rescue StandardError => e
    Logger.warn("Error fetching messages: #{e.message}")
  end

  # def new
  # end

  # def edit
  # end

  def create
    @message = Message.new(message_params)
    @message.user = current_user
    @message.chat_groups = params[:chat_room_id]
    if @message.save
      render json: @message
    else 
      flash.now[:error] = "Could not save message"
      render action: "new" 
    end
    rescue StandardError => e
    Logger.warn("Error creating message: #{e.message}")
  end

  def update
  end

  def destroy
  end
end
