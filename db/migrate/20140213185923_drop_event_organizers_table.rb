class DropEventOrganizersTable < ActiveRecord::Migration
  def change
    drop_table :event_organizers
    add_column :event_rsvps, :organizer, :boolean, { default: false }
    add_index :event_rsvps, :organizer
  end
end
