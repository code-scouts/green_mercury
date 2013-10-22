class RemoveColumnContentFromMemberApplication < ActiveRecord::Migration
  def change
    remove_column :member_applications, :content
  end
end
