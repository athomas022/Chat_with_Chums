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
    @chat_room = ChatRoom.new
  end

  def edit
    @chat_room = ChatRoom.find(params[:id])
  end

    def create
      @chat_room = ChatRoom.new(chat_room_params)
      @chat_room.admin_id = current_user.id
      @chat_room.created_on = Date.today
  
      if @chat_room.save
        redirect_to @chat_room, notice: 'Chat room was successfully created.'
      else
        render :new
      end
    end

  def update
    @chat_room = ChatRoom.find(params[:id]) 
      if @chat_room.admin_id == current_user.id
          if @chat_room.update(chat_room_params)
            redirect_to @chat_room, notice: 'Chat room was successfully updated.'
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
        if @chat_room.save
          unless @chat_room.participants.exists?(user_id: current_user.id)
            participant = @chat_room.participants.create(user_id: current_user.id)
            if participant.persisted?
              Rails.logger.info "User added to participants table"
            else
              Rails.logger.error "Failed to add user to participants table: #{participant.errors.full_messages}"
            end
          end
        else
          Rails.logger.error "Failed to save chat room: #{@chat_room.errors.full_messages}"
        end
      else
        Rails.logger.info "User already joined this chat room"
      end
      
      redirect_to @chat_room
    end

    def leave
      @chat_room = ChatRoom.find(params[:id])
      if @chat_room.users_id.include?(current_user.id)
        @chat_room.users_id.delete(current_user.id)
        if @chat_room.save
          participants = @chat_room.participants.where(user_id: current_user.id)
          if participants.destroy_all
            Rails.logger.info "User removed from participants table"
          else
            Rails.logger.error "Failed to remove user from participants table"
          end
        else
          Rails.logger.error "Failed to save chat room: #{@chat_room.errors.full_messages}"
        end
      end
      redirect_to chat_rooms_path
    end

def remove_participant
  @chat_room = ChatRoom.find(params[:id])
  @user = User.find(params[:user_id])
  if @chat_room.admin_id == current_user.id
    @chat_room.users.delete(@user)
    flash[:notice] = "Participant removed successfully"
  else
    flash[:error] = "You are not authorized to remove participants from this chat room"
  end
  redirect_back(fallback_location: chat_room_path(@chat_room))
end

private

  def chat_room_params
    params.require(:chat_room).permit(:name, :personality_types, :is_public, :announcements, :users_id)
  end
end