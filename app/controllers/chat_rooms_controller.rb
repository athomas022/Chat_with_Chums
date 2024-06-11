class ChatRoomsController < ApplicationController
  def index
    @chat_rooms = ChatRoom.search_by_keyword(params[:keyword])
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @users = @chat_room.users
    @messages = @chat_room.messages
    Rails.logger.info "ChatRoom #{@chat_room.id} has #{@users.count} users"
    @users.each do |user|
      Rails.logger.info "User: #{user.id}, Name: #{user.name}, Picture: #{user.picture?}, Verified: #{user.is_verified}, Online: #{user.is_online}"
    end
    # render json: @chat_room
  rescue StandardError => e
    Rails.logger.warn("Error fetching messages: #{e.message}")
  end

  def new
    render :new
  end

  # def edit
  # end

  def create
   @chat_room = ChatRoom.new(chat_room_params)
   @chat_room.admin_id = current_user
    if @chat_room.save
      render json: @chat_room
    else
      flash.now[:error] = "Could not create the chat room"
      render action: "new"
    end
  rescue StandardError => e
    Rails.logger.warn("Error creating message: #{e.message}")
  end

  def update
    @chat_room = ChatRoom.find(params[:id]) 
      if @chat_room.admin_id == current_user.id
          if @chat_room.update(chat_room_params)
            render json: @chat_room
          else
            flash.now[:error] = "Could not update the chat room details"
            render action: "edit"
          end
      else 
        flash.now[:error] = "Not authorized to update the chat room"
        redirect_back(fallback_location: chat_rooms_path)
      end
    rescue StandardError => e
      Rails.logger.warn("Error updating Chat Room: #{e.message}")
  end

  def destroy
    @chat_room = ChatRoom.find(params[:id])
      if @chat_room.admin_id == current_user.id
         if @chat_room.destroy
           flash[:notification] = "Successfully deleted the chat room"
           rredirect_back(fallback_location: chat_rooms_path)
         else
          flash.now[:error] = "Could not delete the chat room"
          redirect_back(fallback_location: chat_rooms_path)
         end
      else
        flash.now[:error] = "Not authorized to delete the chat room"
        redirect_back(fallback_location: chat_rooms_path)
      end
    rescue StandardError => e
      Rails.logger.warn("Error deleting Chat room: #{e.message}")   
    end


    def join
      @chat_room = ChatRoom.find(params[:id])
      unless @chat_room.users_id.include?(current_user.id)
        @chat_room.users_id << current_user.id
        @chat_room.save
        redirect_to chat_rooms_path
      end
     
    end  

    def leave
      @chat_room = ChatRoom.find(params[:id])
      if @chat_room.users_id.include?(current_user.id)
        @chat_room.users_id.delete(current_user.id)
        @chat_room.save
      end
      redirect_to chat_rooms_path
    end  

private

  def chat_room_params
    params.require(:chat_room).permit(:name, :description)
  end
end