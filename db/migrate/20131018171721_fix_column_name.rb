class FixColumnName < ActiveRecord::Migration
  def change
    remove_column :member_applications, :approved_date
    remove_column :member_applications, :rejected_date
    remove_column :mentor_applications, :approved_date
    remove_column :mentor_applications, :rejected_date
    add_column :member_applications, :approved_date, :datetime
    add_column :member_applications, :rejected_date, :datetime
    add_column :mentor_applications, :approved_date, :datetime
    add_column :mentor_applications, :rejected_date, :datetime 
  end
end
