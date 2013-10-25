class AddIndexesForEventTables < ActiveRecord::Migration
  def change
    add_index :events, :date
    add_index :event_rsvps, [:event_id, :user_uuid], unique: true
    add_index :event_organizers, [:event_id, :user_uuid], unique: true
  end
end
