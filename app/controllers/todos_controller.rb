class TodosController < ApplicationController
  def index
    @today_reminders = Reminder.today.includes(:contact).order(date: :asc)
    @this_week_reminders = Reminder.this_week.includes(:contact).order(date: :asc)
    @all_reminders = Reminder.pending.includes(:contact).order(date: :asc)
    
    # For calendar view
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @calendar_reminders = Reminder.by_date(start_date, end_date).includes(:contact)
    else
      @calendar_reminders = Reminder.by_date(Date.today.beginning_of_month, Date.today.end_of_month).includes(:contact)
    end
  end
end 