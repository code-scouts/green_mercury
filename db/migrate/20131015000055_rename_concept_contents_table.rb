class RenameConceptContentsTable < ActiveRecord::Migration
  def change
    rename_table :concept_contents, :concept_descriptions
  end
end
