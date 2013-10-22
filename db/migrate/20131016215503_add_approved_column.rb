class AddApprovedColumn < ActiveRecord::Migration
  def change
    add_column :mentor_applications, :approved, :boolean
    add_column :member_applications, :approved, :boolean
  end
end
