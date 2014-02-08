class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date
      t.text :user_uuid
      t.integer :max_members
      t.integer :max_mentors
      
      t.timestamps
    end
  end
end
