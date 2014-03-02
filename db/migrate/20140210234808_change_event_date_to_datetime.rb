class ChangeEventDateToDatetime < ActiveRecord::Migration
  def change
    remove_column :events, :date
    remove_column :events, :start_time
    remove_column :events, :end_time
    add_column :events, :start_time, :datetime 
    add_column :events, :end_time, :datetime
  end
end
