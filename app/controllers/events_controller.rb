class EventsController < ApplicationController
  before_action :authorize_organizer, only: [:create, :update, :destroy]
  before_action :authorize_request, only: [:index, :show]
  before_action :set_event, only: [:show, :update, :destroy]

  # GET /events or /events.json
  def index
    @events = Event.all
    render json: @events
  end

  # GET /events/1 or /events/1.json
  def show
    render json: @event
  end

  # POST /events or /events.json
  def create
    @event = @current_user.events.build(event_params)  # Assign event to the logged-in organizer

    if @event.save
      render json: @event, status: :created
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    if @event.event_organizer_id == @current_user.id  # Ensure the organizer owns the event
      if @event.update(event_params)
        NotifyEventUpdateJob.perform_later(@event.id)
        render json: @event, status: :ok
      else
        render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "You can only update your own events" }, status: :forbidden
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    if @event.event_organizer_id == @current_user.id
      @event.destroy!
      render json: { message: "Event was successfully deleted" }, status: :ok
    else
      render json: { error: "You can only delete your own events" }, status: :forbidden
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Event not found" }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.expect(event: [ :name, :date, :venue, :event_organizer_id ])
    end
end
