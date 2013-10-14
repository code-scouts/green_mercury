require 'spec_helper'

feature 'apply to be a mentor' do
  before do
    @user = User.new
    MentorPetitionsController.any_instance.should_receive(:current_user).at_least(1).and_return @user
  end

  scenario 'submit a valid mentor application' do
    visit root_path
    click_link 'Apply to be a mentor'
    fill_in 'mentor_petition_content', with: 'all the languages I know'
    click_button 'Submit Application'
    expect(page).to have_content 'Application Submitted'
  end
end