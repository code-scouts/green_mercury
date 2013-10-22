class CreateMemberPetitions < ActiveRecord::Migration
  def change
    create_table :member_petitions do |t|
      t.text :user_uuid
      t.text :content
      t.date :approved_date

      t.timestamps
    end
  end
end
