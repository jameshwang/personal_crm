module Api
  class RemindersController < Api::BaseController
    before_action :set_reminder, only: [:show, :update, :destroy]

    def index
      @reminders = current_user.reminders
      @reminders = @reminders.where(status: params[:status]) if params[:status].present?
      render_success({ reminders: @reminders })
    end

    def show
      render_success({ reminder: @reminder })
    end

    def create
      @reminder = current_user.reminders.build(reminder_params)
      
      if @reminder.save
        render_success({ reminder: @reminder }, status: :created)
      else
        render_error(@reminder.errors.full_messages)
      end
    end

    def update
      if @reminder.update(reminder_params)
        render_success({ reminder: @reminder })
      else
        render_error(@reminder.errors.full_messages)
      end
    end

    def destroy
      if @reminder.destroy
        render_success({ message: 'Reminder was successfully deleted' })
      else
        render_error('Failed to delete reminder')
      end
    end

    private

    def set_reminder
      @reminder = current_user.reminders.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error('Reminder not found', status: :not_found)
    end

    def reminder_params
      params.require(:reminder).permit(:title, :description, :date, :status, :contact_id)
    end
  end
end 