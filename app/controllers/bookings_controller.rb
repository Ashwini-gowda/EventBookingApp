class BookingsController < ApplicationController
  before_action :authorize_customer
  before_action :set_booking, only: [:show, :update, :destroy]
  # before_action :ensure_customer_owns_booking, only: [:update, :destroy]


  # GET /bookings or /bookings.json
  def index
    @bookings = @current_user.bookings
    render json: @bookings
  end

  # GET /bookings/1 or /bookings/1.json
  def show
    render json: @booking
  end

  # POST /bookings or /bookings.json
  def create
    @booking = @current_user.bookings.build(booking_params)  # Assign booking to logged-in customer

    if @booking.save
      SendBookingConfirmationJob.perform_later(@booking.id)
      render json: @booking, status: :created
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    if @booking.update(booking_params)
      render json: @booking, status: :ok
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    @booking.destroy!
    render json: { message: "Booking successfully canceled" }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    render json: { error: "Booking not found" }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.expect(booking: [ :customer_id, :event_id, :ticket_id, :quantity ])
    end
end
