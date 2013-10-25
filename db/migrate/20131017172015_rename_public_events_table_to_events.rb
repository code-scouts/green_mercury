class RenamePublicEventsTableToEvents < ActiveRecord::Migration
  def change
    rename_table :public_events, :events
  end
end
