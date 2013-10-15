class CreateMentorApplications < ActiveRecord::Migration
  def change
    create_table :mentor_applications do |t|
      t.text :user_uuid
      t.text :content
      t.date :approved_date

      t.timestamps
    end
  end
end
