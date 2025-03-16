class CreateInteractions < ActiveRecord::Migration[8.0]
  def change
    create_table :interactions do |t|
      t.references :contact, null: false, foreign_key: true
      t.datetime :date
      t.string :interaction_type
      t.text :notes

      t.timestamps
    end
  end
end
