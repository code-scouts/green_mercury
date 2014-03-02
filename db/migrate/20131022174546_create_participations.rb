class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.belongs_to :project
      t.text :user_uuid

      t.timestamps
    end
  end
end
