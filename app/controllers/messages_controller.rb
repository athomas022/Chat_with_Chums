class MessagesController < ApplicationController
  def index
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages
    render json: @message
  rescue StandardError => e
    Rails.logger.warn("Error fetching messages: #{e.message}")
    head :internal_server_error
  end

  # def show
  #   @message = Message.where(chat_room_id: params[:chat_room_id]).find(params[:id])
  #     render json: @message
  #   rescue StandardError => e
  #     Rails.logger.warn("Error fetching messages: #{e.message}")
  #     head :not_found
  # end

  # def new
  # end

  # def edit
  # end

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages.new(message_params)
    @message.user_id = current_user.id
    if @message.save
      # render json: @message
      head :ok
    else 
      Rails.logger.error(@message.errors.inspect)
      # flash.now[:error] = "Could not create message"
      # render action: "new" 
      head :unprocessable_entity
    end
    rescue StandardError => e
      Rails.logger.warn("Error creating message: #{e.message}")
      head :internal_server_error
  end

  # def update
  #   @message = Message.find(params[:id])
  #   if @message.update(message_params)
  #     render json: @message
  #   else 
  #    flash.now[:error] = "Could not update the message"
  #    render action: "edit"
  #   end
  #   rescue StandardError => e
  #     Logger.warn("Error updating data: #{e.message}")
  # end

  def destroy
    @message = Message.find(params[:id])
    if @message.destroy
      # flash[:notification] = "Successfully deleted the message"
      head :no_content
      redirect_to ChatRoom.find(params[:chat_room_id])
    else 
      flash.now[:error] = "Could not delete message"
      redirect_back
    end
  rescue StandardError => e
    Logger.warn("Error updating data: #{e.message}")  
  end


  private

  def message_params
    params.require(:message).permit(:body,:user_id, :chat_room_id)
  end

end