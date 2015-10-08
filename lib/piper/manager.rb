
require 'net/http'
require 'oj'

module Piper

  # Piper::Manager is a simple class that is used to manage cached content in a
  # Piper Push Cache server. It uses HTTP request in a REST pattern.
  class Manager

    attr_accessor :host
    attr_accessor :port
    
    def initialize(host, port)
      @host = host
      @port = port
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

  end # Manager

end # Piper
