class AddQuestionColumnsToMemberApplication < ActiveRecord::Migration
  def change
    add_column :member_applications, :why_you_want_to_join, :text
    add_column :member_applications, :gender, :string
    add_column :member_applications, :experience_level, :text
    add_column :member_applications, :confidence_technical_skills, :integer
    add_column :member_applications, :basic_programming_knowledge, :integer
    add_column :member_applications, :comfortable_learning, :integer
    add_column :member_applications, :current_projects, :text
    add_column :member_applications, :time_commitment, :text
    add_column :member_applications, :hurdles, :text 
    add_column :member_applications, :excited_about, :text
    add_column :member_applications, :anything_else, :text 
  end
end
