
require 'oj'

module Piper

  class Manager

    attr_reader :host

    def initialize(host, port)
      @host = host
      @port = port
    end

    def push_json(json)
      # TBD
    end

    def push(obj)
      # TBD
    end

    def delete(rid)
      # TBD
    end

    def get(rid)
      # TBD
    end

    def get_all(filter)
      # TBD
    end

  end # Manager

end # Piper
