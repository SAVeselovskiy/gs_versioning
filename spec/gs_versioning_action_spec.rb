describe Fastlane::Actions::GsVersioningAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The gs_versioning plugin is working!")

      Fastlane::Actions::GsVersioningAction.run(nil)
    end
  end
end
