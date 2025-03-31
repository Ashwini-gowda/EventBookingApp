class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  SECRET_KEY = Rails.application.secret_key_base

  # Before-action method to authenticate users
  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')
      @current_user = find_user(decoded[0]["user_id"], decoded[0]["role"])
    rescue JWT::DecodeError
      render json: { error: 'Unauthorized access' }, status: :unauthorized
    end
  end

  # Restrict access based on role
  def authorize_organizer
    authorize_request
    render json: { error: 'Access denied' }, status: :forbidden unless @current_user.is_a?(EventOrganizer)
  end

  def authorize_customer
    authorize_request
    render json: { error: 'Access denied' }, status: :forbidden unless @current_user.is_a?(Customer)
  end

  private

  # Find user based on role
  def find_user(user_id, role)
    role == 'organizer' ? EventOrganizer.find_by(id: user_id) : Customer.find_by(id: user_id)
  end
end
