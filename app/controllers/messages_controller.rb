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
    @message = Message.find(params[:id])
    if @message.update(message_params)
      render json: @message
    else 
     flash.now[:error] = "Could not update the message"
     render action: "edit"
    end
    rescue StandardError => e
    Logger.warn("Error updating data: #{e.message}")
  end

  def destroy
    @message = Message.find(params[:id])
    if @message.destroy
      flash[:notification] = "Successfully deleted the message"
      redirect_to ChatRoom.find(params[:chat_room_id])
    else 
      flash.now[:error] = "Could not delete message"
      redirect_back
    end
  rescue StandardError => e
    Logger.warn("Error updating data: #{e.message}")  
  end
