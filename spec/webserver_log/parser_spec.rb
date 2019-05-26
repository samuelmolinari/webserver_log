RSpec.describe WebserverLog::Parser do
  subject { described_class.new("spec/fixtures/sample.log") }

  describe "#stats" do
    it "maps views stats to each page" do
      expect(subject.stats).to include(
        '/cats' => {
          views: {
            total: 4,
            unique: 2
          }
        },
        '/dogs' => {
          views: {
            total: 3,
            unique: 3
          }
        }
      )
    end
  end
end
