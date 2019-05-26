require "getoptlong"

class WebserverLog
  class CommandLine
    def initialize
      @options = Options.new
    end

    def execute
      return output_manual if options.help?

      output
    end

    private

    attr_reader :options

    def output
      if options.default?
        output_all
      elsif options.only?(:visits)
        output_visits
      elsif options.only?(:unique_views)
        output_unique_views
      else
        raise Error, "option `--only' only accept `visits' or `unique_views' as argument"
      end
    end

    def webserver_log
      @webserver_log ||= WebserverLog.new(Parser.new(options.path))
    end

    def output_visits(format=options.format)
      output_logs(webserver_log.visits, format)
    end

    def output_unique_views(format=options.format)
      output_logs(webserver_log.unique_views, format)
    end

    def output_all
      output_visits("%{page} %{value} visits")
      puts
      output_unique_views("%{page} %{value} unique views")
    end

    def output_logs(logs, format)
      logs.each do |log|
        puts format % log
      end
    end

    def output_manual
      puts <<-EOF
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

    class Options
      DEFAULT_FORMAT = "%{page} %{value}".freeze
      OPTIONS = [
        ["--help", "-h", GetoptLong::NO_ARGUMENT],
        ["--only", "-o", GetoptLong::REQUIRED_ARGUMENT],
        ["--format", "-f", GetoptLong::REQUIRED_ARGUMENT]
      ].freeze

      attr_reader :path, :format

      def initialize
        @path = ARGV[0]
        @help = false
        @only = nil
        @format = DEFAULT_FORMAT

        parse_options(GetoptLong.new(*OPTIONS))
      end

      def only?(stat)
        @only == stat.to_s
      end

      def default?
        @only.nil?
      end

      def help?
        @help
      end
    
      private

      def parse_options(options)
        options.each do |opt, arg|
          case opt
            when "--help"
              @help = true
            when "--only"
              @only = arg
            when "--format"
              @format = arg
          end
        end
      end
    end
  end
end
