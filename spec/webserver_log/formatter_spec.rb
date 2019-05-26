RSpec.describe WebserverLog::Formatter do
  let(:log) { {page: "hello/world", value: 10} }

  describe ".format" do
    it "returns string in expected format" do
      expect(described_class.strflog(log, "This page %{page} has %{value} views"))
    end
  end
end
