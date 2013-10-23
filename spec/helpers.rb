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

def stub_user_fetch_from_uuid
  User.stub(:fetch_from_uuid).and_return(@user1)
end

def stub_user_fetch_from_uuids
  @user2 ||= User.new

  User.stub(:fetch_from_uuids) do |uuids|
    if uuids == [@user1.uuid]
      { @user1.uuid => @user1 }
    elsif uuids == [@user2.uuid]
      { @user2.uuid => @user2 }
    elsif uuids == []
      {}
    else
      { @user1.uuid => @user1, @user2.uuid => @user2 }
    end
  end
end

def stub_events_controllers
  EventsController.any_instance.stub(:current_user).and_return(@user1)
  EventRsvpsController.any_instance.stub(:current_user).and_return(@user1)
  EventOrganizersController.any_instance.stub(:current_user).and_return(@user1)
end

def create_mentor_and_event
  @user1 = new_mentor
  @event = FactoryGirl.create(:event)
end