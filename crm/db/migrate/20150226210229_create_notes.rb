class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :contact_id
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
