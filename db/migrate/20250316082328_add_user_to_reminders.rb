class AddUserToReminders < ActiveRecord::Migration[7.1]
  def change
    add_reference :reminders, :user, null: true, foreign_key: true
  end
end
