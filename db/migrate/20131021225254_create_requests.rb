class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :title
      t.text :content
      t.text :mentor_uuid
      t.text :member_uuid
      t.text :contact_info

      t.timestamps
    end
  end
end
