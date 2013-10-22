class ChangeMemberPetitionToMemberApplication < ActiveRecord::Migration
  def change
    rename_table :member_petitions, :member_applications
  end
end
