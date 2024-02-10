# frozen_string_literal: true

class ApplicationController < ActionController::API # rubocop:disable Style/Documentation
  def create_token(user_id)
    payload = { user_id: }
    secret_key = Rails.application.credentials.secret_key_base
    JWT.encode(payload, secret_key)
  end

  def authenticate # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    authorization_header = request.headers[:authorization]
    if !authorization_header
      render_unauthorized
    else
      token = authorization_header.split(' ')[1]
      secret_key = Rails.application.credentials.secret_key_base

      begin
        decoded_token = JWT.decode(token, secret_key)
        @current_user = User.find(decoded_token[0]['user_id'])
      rescue ActiveRecord::RecordNotFound
        render_unauthorized
      rescue JWT::DecodeError
        render_unauthorized
      end

    end
  end

  def owner?(model)
    model.user_id == @current_user.id
  end

  def render_unauthorized
    render json: { errors: 'Unauthorized' }, status: :unauthorized
  end
end
