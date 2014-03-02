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
