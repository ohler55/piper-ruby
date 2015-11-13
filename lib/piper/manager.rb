
require 'net/http'
require 'oj'

begin
  require 'nats/client'
rescue Exception
end

module Piper

  # Piper::Manager is a simple class that is used to manage cached content in a
  # Piper Push Cache server. It uses HTTP request in a REST pattern.
  class Manager

    attr_accessor :host
    attr_accessor :port
    
    def initialize(host, port)
      @host = host
      @port = port
      @prev_log_rid = nil
      @nats_url = nil
      @subject = nil
    end

    # Pushes JSON to Piper and associates it with the provided record
    # identifier.
    # @param [String] rid record identifier
    # @param [String] json JSON to store in Piper
    # @return [Net::HTTP::Response] of the send request.
    def push_json(rid, json)
      h = Net::HTTP.new(@host, @port)
      h.send_request('PUT', "/#{rid}", json, {'Content-Type' => 'text/plain; charset=utf-8'})
    end

    # Converts an object to JSON and then pushed that JSON to Piper and
    # associates it with the provided record identifier.
    # @param [String] rid record identifier
    # @param [Object] object Object to convert to JSON before storing
    # @return [Net::HTTP::Response] of the send request.
    def push(rid, obj)
      push_json(rid, Oj::dump(obj, mode: :compat))
    end

    # Deletes a record from the Piper cache.
    # @param [String] rid record identifier of the record to delete
    # @return [Net::HTTP::Response] of the send request.
    def delete(rid)
      h = Net::HTTP.new(@host, @port)
      h.send_request('DELETE', "/#{rid}")
    end

    # Gets a record from the Piper cache. The JSON will be in the body of the
    # response if successful.
    # @param [String] rid record identifier of the record to get
    # @return [Net::HTTP::Response] of the send request.
    def get(rid)
      h = Net::HTTP.new(@host, @port)
      h.send_request('GET', "/#{rid}")
    end

    # Sets up NATS. A connection is not made until a log entry is made or a
    # publish is made. The subject should provided will be the prefix for
    # published records and for log messages. Log messages are published on
    # <subject>.log
    # @param [String] url URL to connect to NATS server e.g., nats://localhost:4222
    # @param [String] subject subkect prefix
    def nats_init(url, subject)
      if (defined? NATS)
        @nats_url = url
        @nats_url = 'nats://localhost:4222' if url.nil?
        @subject = subject
      else
        raise Exception.new("NATS gem not installed.")
      end
    end

    # Publishs a JSON message using a NATS client.
    # @param [String] rid record identifier for the published record
    # @param [Object] object Object to convert to JSON before storing
    def publish(rid, obj)
      NATS.start(:uri => uri) { NATS.publish("#{@subject}.#{rid}", Oj::dump(obj, mode: :compat)) { NATS.stop } }
    end

    # Publishs a JSON message using a NATS client.
    # @param [String] rid record identifier for the published record
    # @param [String] json json to publish to Piper
    def publish_json(rid, json)
      NATS.start(:uri => uri) { NATS.publish("#{@subject}.#{rid}", json) { NATS.stop } }
    end

    # Send a log entry to Piper either by a publish over NATS or by a HTTP PUT.
    # @param [Integer|String|Symbol] level severity level (e.g., 1, "error", or :error)
    # @param [String] what reason or contents of the record
    # @param [String] tid tracking identifier if any
    # @param [String] where where the log even was created, default is <file>:<line>
    # @param [String] the record identifier of the created log record.
    def log(level, what, tid=nil, where=nil)
      rec = LogRec.new(level, what, tid, where)
      rid_num = rec.when.strftime('%Y%m%d%H%M%S%N').to_i
      rid_num = @prev_log_rid + 1 if !@prev_log_rid.nil? && @prev_log_rid >= rid_num
      rid = "#{LogRec.who}-#{rid_num}"
      if @subject.nil?
        push_json(rid, rec.to_s)
      else
        NATS.start(:uri => uri) { NATS.publish("#{@subject}.#{rid}", rec.to_s) { NATS.stop } }
      end
      rid
    end

    # Put or publish a fatal log record.
    # @param [String] what reason or contents of the record
    # @param [String] tid tracking identifier if any
    # @param [String] the record identifier of the created log record.
    def fatal(what, tid=nil)
      log(:fatal, what, tid)
    end

    # Put or publish a error log record.
    # @param [String] what reason or contents of the record
    # @param [String] tid tracking identifier if any
    # @param [String] the record identifier of the created log record.
    def error(what, tid=nil)
      log(:error, what, tid)
    end

    # Put or publish a warning log record.
    # @param [String] what reason or contents of the record
    # @param [String] tid tracking identifier if any
    # @param [String] the record identifier of the created log record.
    def warn(what, tid=nil)
      log(:warn, what, tid)
    end

    # Put or publish a info log record.
    # @param [String] what reason or contents of the record
    # @param [String] tid tracking identifier if any
    # @param [String] the record identifier of the created log record.
    def info(what, tid=nil)
      log(:info, what, tid)
    end

    # Put or publish a debug log record.
    # @param [String] what reason or contents of the record
    # @param [String] tid tracking identifier if any
    # @param [String] the record identifier of the created log record.
    def debug(what, tid=nil)
      log(:debug, what, tid)
    end

  end # Manager

end # Piper
