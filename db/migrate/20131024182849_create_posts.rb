class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :user_uuid
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
