class AddApprovalAndRejectionColumns < ActiveRecord::Migration
  def change
    add_column :mentor_applications, :rejected_date, :date
    add_column :member_applications, :rejected_date, :date 
    remove_column :mentor_applications, :approved
    remove_column :member_applications, :approved
    add_column :member_applications, :rejected_by_user_uuid, :text 
    add_column :mentor_applications, :rejected_by_user_uuid, :text 
    add_column :member_applications, :approved_by_user_uuid, :text 
    add_column :mentor_applications, :approved_by_user_uuid, :text
  end
end
