class ChangeMentorPetitionToMentorApplication < ActiveRecord::Migration
  def change
    rename_table :mentor_petitions, :mentor_applications
  end
end
