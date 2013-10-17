class AddUserUuidToConceptDescriptions < ActiveRecord::Migration
  def change
    remove_column :concept_descriptions, :user_uuid
    add_column :concept_descriptions, :user_uuid, :text
  end
end
