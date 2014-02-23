class RemoveMaxColumns < ActiveRecord::Migration
  def change
    remove_column :projects, :max_members
    remove_column :projects, :max_mentors
  end
end
