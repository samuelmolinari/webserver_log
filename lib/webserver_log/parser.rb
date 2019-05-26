require "set"

class WebserverLog
  class Parser
    attr_reader :stats

    def initialize(path)
      @log_file = File.open(path, "r")
      @stats = {}
      @ip_tracker = {}

      analyse
    end

    private

    attr_reader :log_file, :ip_tracker

    def analyse
      log_file.each { |line| analyse_line(line) }
    end

    def analyse_line(line)
      raise(Error, "Logs should have the format '%{page} %{ip}'") unless valid?(line)

      page, ip_address = line.split(' ')
      update_page_stats(page, ip_address)
    end

    def valid?(line)
      line.match? /.+? .+?/
    end

    def update_page_stats(page, ip_address)
      views = (stats[page] ||= new_page_stats)[:views]

      views[:total] += 1
      views[:unique] = track(page, ip_address).size
    end

    def track(page, ip_address)
      (ip_tracker[page] ||= Set.new).add(ip_address)
    end

    def new_page_stats
      {views: {total: 0, unique: 0}}
    end
  end
end
