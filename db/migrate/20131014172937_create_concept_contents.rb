class CreateConceptContents < ActiveRecord::Migration
  def change
    create_table :concept_contents do |t|
      t.string :user_uuid
      t.text :content
      t.integer :concept_id

      t.timestamps
    end
  end
end
