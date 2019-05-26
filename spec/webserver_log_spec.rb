RSpec.describe WebserverLog do
  subject { described_class.new("spec/fixtures/sample.log") }

  it "has a version number" do
    expect(WebserverLog::VERSION).not_to be nil
  end

  describe "#most_views" do
    it "returns pages ordered by total views" do
      expect(subject.most_views).to eq([
        { page: "/cats", total_views: 4 },
        { page: "/dogs", total_views: 3 }
      ])
    end
  end
end
