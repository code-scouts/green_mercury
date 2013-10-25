class RenameRequestsTableToMeetingRequests < ActiveRecord::Migration
  def change
    rename_table :requests, :meeting_requests
  end
end
