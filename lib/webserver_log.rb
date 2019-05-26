require "webserver_log/version"
require "webserver_log/parser"

class WebserverLog
  class Error < StandardError; end

  def initialize(path)
    @stats = Parser.new(path).stats
  end

  def most_views
    stats
      .map { |page, page_stats| {page: page, total_views: total_views(page_stats)} }
      .sort { |log| log[:total_views] }
      .reverse
  end

  private

  attr_reader :stats

  def total_views(page_stats)
    page_stats[:views][:total]
  end
end
