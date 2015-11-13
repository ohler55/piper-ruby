
require 'oj'

module Piper

  # Piper::LogRec is a class for creating JSON log records for Piper Push Cache
  # server.
  class LogRec
    @@level_map = {
      'fatal' => 0,
      'error' => 1,
      'warn' => 2,
      'info' => 3,
      'debug' => 4,
      :fatal => 0,
      :error => 1,
      :warn => 2,
      :info => 3,
      :debug => 4,
    }
    @@who = File.basename($PROGRAM_NAME)

    def self.who()
      return @@who
    end
    attr_reader :kind
    attr_accessor :when
    attr_accessor :who
    attr_accessor :where
    attr_accessor :what
    attr_accessor :tid

    def initialize(level, what, tid=nil, where=nil)
      @kind = 'Log'
      if level.is_a?(Integer)
        @level = level
      else
        @level = @@level_map[level]
      end
      @who = @@who
      if where.nil?
        loc = caller_locations(2,1)[0]
        @where = "#{File.basename(loc.path)}:#{loc.lineno}"
      else
        @where = where
      end
      @what = what
      @when = Time.now
      @when.gmtime unless @when.gmt?
      @tid = tid
    end

    def to_s()
      Oj.dump(self, :mode => :compat, :time_format => :unix)
    end

  end # LogRec

end # Piper
