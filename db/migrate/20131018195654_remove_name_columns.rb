class RemoveNameColumns < ActiveRecord::Migration
  def change
    remove_column :member_applications, :name 
    remove_column :mentor_applications, :name
  end
end
