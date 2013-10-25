class AddNameToMemberApplication < ActiveRecord::Migration
  def change
    add_column :member_applications, :name, :string
  end
end
