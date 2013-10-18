class RenameContentColumn < ActiveRecord::Migration
  def change
    rename_column :concept_contents, :content, :description
  end
end
