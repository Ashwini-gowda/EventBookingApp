class AuthController < ApplicationController
  require 'jwt'

  SECRET_KEY = Rails.application.secret_key_base
  skip_before_action :verify_authenticity_token, only: [:customer_login]
  # Event Organizer Login
  def event_organizer_login
    organizer = EventOrganizer.find_by(email: params[:email])
    if organizer&.authenticate(params[:password])
      token = encode_token(organizer.id, 'organizer')
      render json: { token: token, role: 'organizer' }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  # Customer Login
  def customer_login
    customer = Customer.find_by(email: params[:email])
    puts customer.password_digest
    if customer&.authenticate(params[:password])
      token = encode_token(customer.id, 'customer')
      render json: { token: token, role: 'customer' }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  # Encode JWT Token
  def encode_token(user_id, role)
    payload = { user_id: user_id, role: role, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end
end
