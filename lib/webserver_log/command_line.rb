require "getoptlong"

class WebserverLog
  class CommandLine
    OPTIONS = [
      ["--help", "-h", GetoptLong::NO_ARGUMENT],
      ["--views", "-v", GetoptLong::REQUIRED_ARGUMENT],
      ["--format", "-f", GetoptLong::REQUIRED_ARGUMENT]
    ].freeze

    def initialize
      @path = ARGV[0]
      @help = false
      @views = nil
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

      if order_by?(:total)
        output_logs(webserver_log.most_views, @format)
      elsif order_by?(:unique)
        output_logs(webserver_log.most_unique_views, @format)
      else
        raise Error, "option `--views' only accept `total' or `unique' as argument"
      end
    end

    def parse_options(options)
      options.each do |opt, arg|
        case opt
          when "--help"
            @help = true
          when "--views"
            @views = arg
          when "--format"
            @format = arg
        end
      end
    end

    def order_by?(stat)
      @views == stat.to_s
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

  -v, --views [total|unique]:
    total: List pages by most views
    unique: List pages by most unique views

  -f, --format:
    With the -v option, you can choose the output format of the ouput
    default: "%{page} %{value}"
      EOF
    end
  end
end
