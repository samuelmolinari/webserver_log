class WebserverLog
  class Formatter
    def self.strflog(log, format)
      format % log
    end
  end
end
