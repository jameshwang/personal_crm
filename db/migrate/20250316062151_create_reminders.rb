class CreateReminders < ActiveRecord::Migration[8.0]
  def change
    create_table :reminders do |t|
      t.references :contact, null: false, foreign_key: true
      t.datetime :date
      t.string :title
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
