# module Helpers
#   def stub_fetch_from_uuids
#     User.stub(:fetch_from_uuids) do |uuids|
#       if uuids == [@user1.uuid]
#         { @user1.uuid => @user1 }
#       elsif uuids == [@user2.uuid]
#         { @user2.uuid => @user2 }
#       elsif uuids == []
#         []
#       else
#         { @user1.uuid => @user1, @user2.uuid => @user2 }
#       end
#     end
#   end

#   def stub_current_user_in_event_related_controllers
#     EventsController.any_instance.stub(:current_user).and_return(@user1)
#     EventRsvpsController.any_instance.stub(:current_user).and_return(@user1)
#     EventOrganizersController.any_instance.stub(:current_user).and_return(@user1)
#   end

#   def create_user_and_event
#     @user = FactoryGirl.build(:user)
#     @event = FactoryGirl.create(:event)
#   end
# end