class DropPostsAndReplies < ActiveRecord::Migration
  def change
    drop_table :posts 
    drop_table :replies 
  end
end
