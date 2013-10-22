class AddColumnsToMentorApplications < ActiveRecord::Migration
  def change
    add_column :mentor_applications, :name, :string
    add_column :mentor_applications, :contact, :string
    add_column :mentor_applications, :geography, :string
    add_column :mentor_applications, :shirt_size, :string
    add_column :mentor_applications, :hear_about, :string
    add_column :mentor_applications, :motivation, :text
    add_column :mentor_applications, :time_commitment, :string
    add_column :mentor_applications, :mentor_one_on_one, :string
    add_column :mentor_applications, :mentor_group, :string
    add_column :mentor_applications, :mentor_online, :string
    add_column :mentor_applications, :volunteer_events, :string
    add_column :mentor_applications, :volunteer_teams, :string
    add_column :mentor_applications, :volunteer_solo, :string
    add_column :mentor_applications, :volunteer_technical, :string
    add_column :mentor_applications, :volunteer_online, :string
    remove_column :mentor_applications, :content
  end
end
