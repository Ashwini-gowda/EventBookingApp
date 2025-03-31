class EventOrganizersController < ApplicationController
  before_action :set_event_organizer, only: %i[ show edit update destroy ]

  # GET /event_organizers or /event_organizers.json
  def index
    @event_organizers = EventOrganizer.all
    render json: @event_organizers
  end

  # GET /event_organizers/1 or /event_organizers/1.json
  def show
    render json: @event_organizer
  end

  # POST /event_organizers or /event_organizers.json
  def create
    @event_organizer = EventOrganizer.new(event_organizer_params)
    if @event_organizer.save
      render json: @event_organizer, status: :created
    else
      render json: { errors: @event_organizer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /event_organizers/1 or /event_organizers/1.json
  def update
    if @event_organizer.update(event_organizer_params)
      render json: @event_organizer, status: :ok
    else
      render json: { errors: @event_organizer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /event_organizers/1 or /event_organizers/1.json
  def destroy
    @event_organizer.destroy!
    render json: { message: "Event organizer successfully deleted" }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_organizer
      @event_organizer = EventOrganizer.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def event_organizer_params
      params.expect(event_organizer: [ :name, :email, :password_digest ])
    end
end
