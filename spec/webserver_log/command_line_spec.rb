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

  -o, --only [visits|unique_views]:
    visits: List pages by most views
    unique_views: List pages by most unique views

  -f, --format:
    With the -o option, you can choose the output format of the ouput
    default: "%{page} %{value}"
      EOF
    end

    it "outputs help manual" do
      expect { subject.execute }.to output(expected_output).to_stdout
    end
  end


  describe "--only" do
    context "without arguments" do
      before do
        ARGV.replace ["spec/fixtures/sample.log", "--only"]
      end

      it "raises an error" do
        expect { subject.execute }.to raise_error(
          "option `--only' requires an argument"
        )
      end
    end

    context "with invalid argument" do
      before do
        ARGV.replace ["spec/fixtures/sample.log", "--only", "undefined"]
      end

      it "raises an error" do
        expect { subject.execute }.to raise_error(
          "option `--only' only accept `visits' or `unique_views' as argument"
        )
      end
    end

    context "with total argument" do
      before do
        ARGV.replace ["spec/fixtures/sample.log", "--only", "visits"]
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
            "--only",
            "visits",
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
        ARGV.replace ["spec/fixtures/sample.log", "--only", "unique_views"]
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
            "--only",
            "unique_views",
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
