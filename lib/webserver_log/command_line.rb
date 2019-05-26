require "getoptlong"

class WebserverLog
  class CommandLine
    OPTIONS = [
      ["--help", "-h", GetoptLong::NO_ARGUMENT],
      ["--views", "-v", GetoptLong::REQUIRED_ARGUMENT]
    ].freeze

    def initialize
      @path = ARGV[0]
      @help = false
      @views = nil

      parse_options(GetoptLong.new(*OPTIONS))
    end

    def execute
      return output_manual if help?

      output_logs
    end

    private

    def output_logs
      puts logs.map { |log| "#{log[:page]} #{log[:value]}" }
    end

    def logs
      webserver_log = WebserverLog.new(@path)

      if order_by?(:total)
        webserver_log.most_views
      elsif order_by?(:unique)
        webserver_log.most_unique_views
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
        end
      end
    end

    def order_by?(stat)
      @views == stat.to_s
    end

    def help?
      @help
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
      EOF
    end
  end
end
