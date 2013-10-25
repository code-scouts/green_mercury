class AddIndexForApplications < ActiveRecord::Migration
  def change
    add_index :member_applications, :user_uuid
    add_index :mentor_applications, :user_uuid
  end
end
