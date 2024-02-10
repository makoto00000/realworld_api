# frozen_string_literal: true

module Api
  class AuthenticationController < ApplicationController # rubocop:disable Style/Documentation
    def login
      @user = User.find_by_email(params[:user][:email])
      if @user&.authenticate(params[:user][:password])
        token = create_token(@user.id)
        render json: { user: { email: @user.email, token:, username: @user.username, bio: @user.bio,
                               image: @user.image } }
      else
        render json: { errors: { body: { message: ['email or password is invalid'] } } }, status: :unauthorized
      end
    end
  end
end
