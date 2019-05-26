RSpec.describe WebserverLog do
  subject { described_class.new("spec/fixtures/sample.log") }

  it "has a version number" do
    expect(WebserverLog::VERSION).not_to be nil
  end

  describe "#visits" do
    it "returns pages ordered by total views" do
      expect(subject.visits).to eq([
        { page: "/cats", value: 4 },
        { page: "/dogs", value: 3 }
      ])
    end
  end

  describe "#unique_views" do
    it "returns pages ordered by unique views" do
      expect(subject.unique_views).to eq([
        { page: "/dogs", value: 3 },
        { page: "/cats", value: 2 }
      ])
    end
  end
end
