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

def stub_application_controller
  ApplicationController.any_instance.stub(:current_user).and_return(@user)
end

def stub_user_fetch_from_uuid
  User.stub(:fetch_from_uuid).and_return(@user)
end

def stub_user_fetch_from_uuids
  @user2 ||= User.new

  User.stub(:fetch_from_uuids) do |uuids|
    if uuids == [@user.uuid]
      { @user.uuid => @user }
    elsif uuids == [@user2.uuid]
      { @user2.uuid => @user2 }
    elsif uuids == []
      {}
    else
      { @user.uuid => @user, @user2.uuid => @user2 }
    end
  end
end

def create_mentor_and_event
  @user = new_mentor
  @event = FactoryGirl.create(:event)
end