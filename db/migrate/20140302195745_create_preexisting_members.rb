class CreatePreexistingMembers < ActiveRecord::Migration
  def change
    create_table :preexisting_members do |t|
      t.string :email
      t.boolean :is_mentor
    end
  end
end
