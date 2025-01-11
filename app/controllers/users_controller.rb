class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.username = "#{user_params[:name]}-#{SecureRandom.hex(4)}"

    if @user.save
      session[:current_user_id] = @user.id
      redirect_to rooms_path, notice: "Signed up!"
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  def user_params
    params.require(:user).permit(:name)
  end
end
