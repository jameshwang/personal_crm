class ChangeContactIdToNullableInReminders < ActiveRecord::Migration[7.1]
  def change
    change_column_null :reminders, :contact_id, true
  end
end
