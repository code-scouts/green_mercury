class AddColumnToParticipations < ActiveRecord::Migration
  def change
    add_column :participations, :role, :string
  end
end
