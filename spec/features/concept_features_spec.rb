require 'spec_helper'

feature 'create concepts' do
  before :each do
    @user = User.new
    @user.uuid = '1'
    @user.name = 'Captain Awesome'
    FactoryGirl.create(:approved_mentor_application, user_uuid: @user.uuid)
    User.stub(:fetch_from_uuids).and_return({ @user.uuid => @user })
    ConceptsController.any_instance.stub(:current_user).and_return(@user)
  end
  
  scenario 'user fills out all fields correctly' do
    visit new_concept_path
    fill_in 'concept_name', with: 'New Concept'
    fill_in 'Description', with: 'This does stuff'
    click_button('Add Concept')
    page.should have_content 'Your concept has been added.'
  end

  scenario 'user does not fill in description' do
    visit new_concept_path
    fill_in 'concept_name', with: 'New Concept'
    click_button('Add Concept')
    page.should have_content 'error'
  end

  scenario 'user does not fill in name' do
    visit new_concept_path
    fill_in 'Description', with: 'This does stuff'
    click_button('Add Concept')
    page.should have_content 'error'
  end
end

feature 'view concepts by name' do 
  scenario 'user clicks link to view all concepts' do
    concept = FactoryGirl.create(:concept_description)
    visit concepts_path
    page.should have_content concept.concept.name
  end
end

feature 'revert to older description' do
  before do
    @user = User.new
    @user.uuid = '1'
    @user.name = 'Captain Awesome'
    FactoryGirl.create(:approved_mentor_application, user_uuid: @user.uuid)
    User.stub(:fetch_from_uuids).and_return({ @user.uuid => @user })
    ConceptsController.any_instance.stub(:current_user).and_return(@user)
    @concept = FactoryGirl.create(:concept)
    @concept.concept_descriptions.create(description: 'better description', user_uuid: @user.uuid)
  end

  scenario 'user reverts to previous description' do
    description2 = @concept.concept_descriptions.create(description: 'get rid of this', user_uuid: @user.uuid)
    visit concept_path(@concept)
    click_link 'Revert to previous description'
    page.should_not have_content description2.description
  end

  scenario 'user cannot revert if there are no previous descriptions' do
    visit concept_path(@concept)
    page.should_not have_content 'Revert'
  end
end

feature 'add a new description to existing concept' do
  before do
    @user = User.new
    @user.uuid = '1'
    @user.name = 'Captain Awesome'
    FactoryGirl.create(:approved_mentor_application, user_uuid: @user.uuid)
    User.stub(:fetch_from_uuids).and_return({ @user.uuid => @user })
    ConceptsController.any_instance.stub(:current_user).and_return(@user)
    ConceptDescriptionsController.any_instance.stub(:current_user).and_return(@user)
    @concept = FactoryGirl.create(:concept)
    @concept.concept_descriptions.create(description: 'better description', user_uuid: @user.uuid)
    visit concept_path(@concept)
    click_link 'Edit description'
  end

  scenario 'user adds a valid description' do
    fill_in 'concept_description_description', with: 'latest description'
    click_button('Save')
    page.should have_content 'latest description'
  end

  scenario 'user adds an invalid description' do
    fill_in 'concept_description_description', with: ''
    click_button('Save')
    page.should_not have_link 'Revert to previous description'
  end

  scenario 'user clicks cancel button', js: true do
    
    click_button('Cancel')
    page.should have_content 'Edit description'
  end
end

feature 'delete a description' do
  scenario 'user deletes a description' do
    @user = User.new
    @user.uuid = '1'
    @user.name = 'Captain Awesome'
    FactoryGirl.create(:approved_mentor_application, user_uuid: @user.uuid)
    User.stub(:fetch_from_uuids).and_return({ @user.uuid => @user })
    ConceptsController.any_instance.stub(:current_user).and_return(@user)
    concept = FactoryGirl.create(:concept)
    description1 = concept.concept_descriptions.create(description: 'better description', user_uuid: @user.uuid)
    description2 = concept.concept_descriptions.create(description: 'best description', user_uuid: @user.uuid)
    visit concept_path(concept)
    click_link 'Delete'
    page.should_not have_content description1.description
  end
end

feature 'view all concepts' do  
  scenario 'click on concept name' do 
    @user = User.new
    @user.uuid = '1'
    @user.name = 'Captain Awesome'
    FactoryGirl.create(:approved_mentor_application, user_uuid: @user.uuid)
    User.stub(:fetch_from_uuids).and_return({ @user.uuid => @user })
    ConceptsController.any_instance.stub(:current_user).and_return(@user)
    concept = FactoryGirl.create(:concept)
    description = concept.concept_descriptions.create(description: 'better description', user_uuid: @user.uuid)
    visit concepts_path
    click_link concept.name
    page.should have_content description.description
  end
end

