class EventsController < ApplicationController

  def index
    @events = Event.all
    start_date = params.fetch(:start_date, Date.today).to_date
    @events = Event.where(start_date: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week).or(Event.where(end_date: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)).order(start_date: :asc)
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    redirect_to events_path unless current_user.admin?
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @events = Event.all
    @event.user = current_user
    if @event.save
      redirect_to events_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    redirect_to events_path unless current_user.admin?
    @event = Event.find(params[:id])
  end

  def update
    redirect_to events_path unless current_user.admin?
    @event = Event.find(params[:id])
    @event.update(event_params)
    if @event.save
      redirect_to events_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    redirect_to events_path unless current_user.admin?
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, status: :see_other
  end

  private

  def event_params
    params.require(:event).permit(:event_name, :description, :location, :start_date, :end_date)
  end
end
