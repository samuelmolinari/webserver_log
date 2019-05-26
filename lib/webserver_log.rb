require "webserver_log/version"
require "webserver_log/parser"

class WebserverLog
  class Error < StandardError; end

  def initialize(path)
    @stats = Parser.new(path).stats
  end

  def most_views
    order_page_by(:total)
  end

  def most_unique_views
    order_page_by(:unique)
  end

  private

  attr_reader :stats

  def order_page_by(stat)
    stats
      .map do |page, page_stats|
        {page: page, value: page_stats[:views][stat]}
      end
      .sort_by { |log| log[:value] }
      .reverse
  end
end
