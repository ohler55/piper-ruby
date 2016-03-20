
require 'oj'

module Piper

  # Piper::Actor module provides a shell for a spawned Piper Push Cache task
  # actor. Piper Push Cache supports process flows where the individual tasks in
  # a flow can be implemented as a separate application that is spawned when it
  # is needed. The spawned application is expected to continue to run and accept
  # input on stdin. Output is over stdout. Both the input and output are JSON
  # strings. This module takes care of the parsing and serialization.
  #
  # The JSON format for input is a JSON object with an 'id' field and a 'rec'
  # field. The output expected is an 'id' field, 'rec' field, and a 'link' field
  # that identifies the link to follow.
  module Actor

    # Starts a JSON processing loop that reads from $stdin. The proc provided
    # with the call should call ship() to continue on with the processing.
    def self.process()
      Oj::load($stdin, :mode => :strict) { |json|
        begin
          id = json['id']
          rec = json['rec']
          yield(id, rec)
        rescue Exception => e
          ship(id, { 'kind' => 'Error', 'message' => e.message, 'class' => e.class.to_s }, 'error')
        end
      }
    end

    # Ships or sends a response to the calling task in the Piper Flow.
    def self.ship(id, rec, link)
      $stdout.puts Oj::dump({ 'id' => id, 'rec' => rec, 'link' => link }, :mode => :strict )
      $stdout.flush()
    end

  end # Actor
end # Piper

