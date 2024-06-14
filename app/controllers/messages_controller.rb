class MessagesController < ApplicationController
  def index
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @messages = @chat_room.messages
    render json: @messages
  rescue StandardError => e
    Rails.logger.warn("Error fetching messages: #{e.message}")
    head :internal_server_error
  end

  def show
    @message = Message.where(chat_room_id: params[:chat_room_id]).find(params[:id])
    render json: @message
  rescue StandardError => e
    Rails.logger.warn("Error fetching message: #{e.message}")
    head :not_found
  end

  def new
  end

  def edit
  end

  def create
    @chat_room = ChatRoom.find_by(id: params[:chat_room_id])
    
    if @chat_room.nil?
      redirect_to root_path, alert: 'Chat room not found' and return
    end

    @message = @chat_room.messages.new(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.html { redirect_to @chat_room, notice: 'Message was successfully created.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new, alert: 'Message could not be created.' }
        format.js { render :new }
      end
    end
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
    Rails.logger.warn("Error updating message: #{e.message}")
  end

  def destroy
    @message = Message.find(params[:id])
    if @message.destroy
      head :no_content
    else
      flash.now[:error] = "Could not delete message"
      redirect_back fallback_location: chat_room_path(params[:chat_room_id])
    end
  rescue StandardError => e
    Rails.logger.warn("Error deleting message: #{e.message}")
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end

