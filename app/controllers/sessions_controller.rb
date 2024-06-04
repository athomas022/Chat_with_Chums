class SessionsController < ApplicationController
  # def new
  # end

  def create
  end

  def destroy
  end

  private

  def generate_jwt(user)
    JWT.encode({ id: user.id, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end



end
