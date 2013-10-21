class CreateMentorPetitions < ActiveRecord::Migration
  def change
    create_table :mentor_petitions do |t|
      t.text :user_uuid
      t.text :content
      t.date :approved_date

      t.timestamps
    end
  end
end
