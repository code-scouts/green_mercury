class AddTypeColumnToParticipations < ActiveRecord::Migration
  def change
    add_column :participations, :type, :string
  end
end
