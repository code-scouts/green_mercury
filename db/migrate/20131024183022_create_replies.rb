class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :user_uuid
      t.integer :post_id
      t.text :content

      t.timestamps
    end
  end
end
