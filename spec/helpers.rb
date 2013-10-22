def new_member 
  user = FactoryGirl.build(:user)
  FactoryGirl.create(:approved_member_application, user_uuid: user.uuid)
  user
end

def new_mentor
  user = FactoryGirl.build(:user)
  FactoryGirl.create(:approved_mentor_application, user_uuid: user.uuid)
  user
end

def stub_requests_controllers
  RequestsController.any_instance.stub(:current_user).and_return(@user1)
end