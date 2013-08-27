class AddMeetupToken < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string :meetup_token
    end
  end
end
