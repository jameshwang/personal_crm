class RemindersController < ApplicationController
  before_action :set_contact
  before_action :set_reminder, only: [:update, :destroy]

  def index
    @reminders = @contact.reminders.order(date: :asc)
    @reminder = @contact.reminders.new
  end

  def create
    @reminder = @contact.reminders.new(reminder_params)

    if @reminder.save
      redirect_to contact_reminders_path(@contact), notice: 'Reminder was successfully created.'
    else
      redirect_to contact_reminders_path(@contact), alert: @reminder.errors.full_messages.join(", ")
    end
  end

  def update
    if @reminder.update(reminder_params)
      redirect_to contact_reminders_path(@contact), notice: 'Reminder was successfully updated.'
    else
      redirect_to contact_reminders_path(@contact), alert: @reminder.errors.full_messages.join(", ")
    end
  end

  def destroy
    @reminder.destroy
    redirect_to contact_reminders_path(@contact), notice: 'Reminder was successfully deleted.'
  end

  private

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def set_reminder
    @reminder = @contact.reminders.find(params[:id])
  end

  def reminder_params
    params.require(:reminder).permit(:title, :description, :date, :status)
  end
end
