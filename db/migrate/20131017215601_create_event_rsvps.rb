class CreateEventRsvps < ActiveRecord::Migration
  def change
    create_table :event_rsvps do |t|
      t.text :user_uuid
      t.integer :event_id

      t.timestamps
    end
  end
end
