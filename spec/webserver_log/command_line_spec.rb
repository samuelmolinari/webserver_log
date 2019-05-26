RSpec.describe WebserverLog::CommandLine do
  subject { described_class.new }

  describe "default options" do
    before do
      ARGV.replace ["spec/fixtures/sample.log"]
    end

    let(:expected_output) do
      <<-EOF
/cats 4 visits
/dogs 3 visits

/dogs 3 unique views
/cats 2 unique views
      EOF
    end

    it "outputs pages with unique views in descending order" do
      expect { subject.execute }.to output(expected_output).to_stdout
    end
  end

  describe  "--help" do
    before do
      ARGV.replace ["--help"]
    end

    let(:expected_output) do
      <<-EOF
parser log_file [OPTIONS]

OPTIONS:

  -h, --help:
    Show help

  -v, --views [total|unique]:
    total: List pages by most views
    unique: List pages by most unique views

  -f, --format:
    With the -v option, you can choose the output format of the ouput
    default: "%{page} %{value}"
      EOF
    end

    it "outputs help manual" do
      expect { subject.execute }.to output(expected_output).to_stdout
    end
  end

  describe "--views" do
    context "without arguments" do
      before do
        ARGV.replace ["spec/fixtures/sample.log", "--views"]
      end

      it "raises an error" do
        expect { subject.execute }.to raise_error(
          "option `--views' requires an argument"
        )
      end
    end

    context "with invalid argument" do
      before do
        ARGV.replace ["spec/fixtures/sample.log", "--views", "undefined"]
      end

      it "raises an error" do
        expect { subject.execute }.to raise_error(
          "option `--views' only accept `total' or `unique' as argument"
        )
      end
    end

    context "with total argument" do
      before do
        ARGV.replace ["spec/fixtures/sample.log", "--views", "total"]
      end

      let(:expected_output) do
        <<-EOF
/cats 4
/dogs 3
        EOF
      end

      it "outputs pages with total views in descending order" do
        expect { subject.execute }.to output(expected_output).to_stdout
      end

      context "with custom format" do
        before do
          ARGV.replace [
            "spec/fixtures/sample.log",
            "--views",
            "total",
            "--format",
            "Page %{page} has %{value} visits"
          ]
        end

        let(:expected_output) do
          <<-EOF
Page /cats has 4 visits
Page /dogs has 3 visits
          EOF
        end

        it "outputs pages in given format" do
          expect { subject.execute }.to output(expected_output).to_stdout
        end
      end
    end

    context "with unique argument" do
      before do
        ARGV.replace ["spec/fixtures/sample.log", "--views", "unique"]
      end

      let(:expected_output) do
        <<-EOF
/dogs 3
/cats 2
        EOF
      end

      it "outputs pages with unique views in descending order" do
        expect { subject.execute }.to output(expected_output).to_stdout
      end

      context "with custom format" do
        before do
          ARGV.replace [
            "spec/fixtures/sample.log",
            "--views",
            "unique",
            "--format",
            "Page %{page} has %{value} unique views"
          ]
        end

        let(:expected_output) do
          <<-EOF
Page /dogs has 3 unique views
Page /cats has 2 unique views
          EOF
        end

        it "outputs pages in given format" do
          expect { subject.execute }.to output(expected_output).to_stdout
        end
      end
    end
  end
end
