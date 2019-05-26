require "getoptlong"

class WebserverLog
  class CommandLine
    OPTIONS = [
      ["--help", "-h", GetoptLong::NO_ARGUMENT],
      ["--only", "-o", GetoptLong::REQUIRED_ARGUMENT],
      ["--format", "-f", GetoptLong::REQUIRED_ARGUMENT]
    ].freeze

    def initialize
      @path = ARGV[0]
      @help = false
      @only = nil
      @format = "%{page} %{value}"

      parse_options(GetoptLong.new(*OPTIONS))
    end

    def execute
      return output_manual if help?

      output
    end

    private

    def output
      webserver_log = WebserverLog.new(@path)

      if only?(:visits)
        output_logs(webserver_log.visits, @format)
      elsif only?(:unique_views)
        output_logs(webserver_log.unique_views, @format)
      elsif default?
        output_logs(webserver_log.visits, "%{page} %{value} visits")
        puts
        output_logs(webserver_log.unique_views, "%{page} %{value} unique views")
      else
        raise Error, "option `--only' only accept `visits' or `unique_views' as argument"
      end
    end

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

    def only?(stat)
      @only == stat.to_s
    end

    def default?
      @only.nil?
    end

    def help?
      @help
    end

    def output_logs(logs, format)
      logs.each do |log|
        puts Formatter.strflog(log, format)
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
  end
end
