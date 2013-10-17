class CreateEventOrganizers < ActiveRecord::Migration
  def change
    create_table :event_organizers do |t|
      t.text :user_uuid
      t.integer :event_id

      t.timestamps
    end
  end
end
