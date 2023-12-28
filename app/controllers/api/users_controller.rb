class Api::UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    token = create_token(@user.id)
    if @user.save
      render json: {user: {email: @user.email, token: token, username: @user.username, bio: @user.bio, image: @user.image}}, status: :created
    else
      render json: {errors: {body: @user.errors}}, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :bio, :image)
  end
end
