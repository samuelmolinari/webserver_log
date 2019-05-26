RSpec.describe WebserverLog::Parser do
  context "with invalid logs" do

    it "raises an error" do
      expect { described_class.new("spec/fixtures/invalid.log") }.to raise_error(
        "Logs should have the format '%{page} %{ip}'"
      )
    end
  end

  context "with valid logs" do
    subject { described_class.new("spec/fixtures/sample.log") }

    describe "#stats" do
      it "maps views stats to each page" do
        expect(subject.stats).to match(
          hash_including(
            '/cats' => hash_including(
              views: hash_including(
                total: 4,
                unique: 2
              )
            ),
            '/dogs' => hash_including(
              views: hash_including(
                total: 3,
                unique: 3
              )
            )
          )
        )
      end
    end
  end
end
