class Api::UsersController < ApplicationController

  before_action :authenticate, only: %i[current_user update]

  def create
    @user = User.new(user_params)
    token = create_token(@user.id)
    if @user.save
      render json: {user: {email: @user.email, token: token, username: @user.username, bio: @user.bio, image: @user.image}}, status: :created
    else
      render json: {errors: {body: @user.errors}}, status: :unprocessable_entity
    end
  end
  
  def current_user
    if @current_user
      render_user(@current_user)
    else
      render json: {errors: {body: @current_user.errors}}, status: :unprocessable_entity
    end
  end

  def update
    @user = @current_user
    if @user.update(user_params)
      render_user(@user)
    else
      render json: {errors: {body: @user.errors}}, status: :unprocessable_entity

    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :bio, :image)
  end

  def render_user(user)
    render json: {user: {email: user.email, token: user.token, username: user.username, bio: user.bio, image: user.image}}
  end
end
