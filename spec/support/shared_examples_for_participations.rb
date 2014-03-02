shared_examples "a participation" do
  let(:project) { FactoryGirl.create(:project) }
  let!(:unfilled_participation) { described_class.create(project_id: project.id, user_uuid: nil, role: 'Some Role') }
  let!(:filled_participation) { described_class.create(project_id: project.id, user_uuid: 'someUserID', role: 'Some Other Role') }

  describe '.unfilled' do
    it 'gets participations not already filled by a user' do
      expect(described_class.unfilled.map(&:id)).to \
        match_array [unfilled_participation.id]
    end
  end
end

shared_examples "an application" do
  let(:user) { FactoryGirl.build(:user) }

  describe 'approve_me' do
    it 'creates an approved record' do
      application = described_class.approve_me(user)
      application.approved?.should be_true
      application.user_uuid.should == user.uuid
    end

    it "puts placeholders in the required fields" do
      application = described_class.approve_me(user)
      described_class.validators.each do |validator|
        validator.instance_variable_get(:@attributes).each do |attr|
          next if [:user_uuid, :comfortable_learning].member? attr
          #user_uuid is validated but not stubbed
          #comfortable_learning is an integer
          begin
            application.send(attr).should == '<pre-existing user>'
          rescue RSpec::Expectations::ExpectationNotMetError => e
            raise $!, "while checking #{attr}: #{e.message}", $!.backtrace
          end
        end
      end
    end
  end
end
