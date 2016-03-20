#!/usr/bin/env ruby
# encoding: UTF-8

$VERBOSE = true

$: << File.join(File.dirname(File.dirname(File.expand_path(__FILE__))), 'lib')

require 'piper'
require 'oj'

# Try executing this file and then typing in the string to the console
#
# {"id":"abc","rec":{"kind":"Test", "num":3}}
#
# The following should appear on stderr which is used for debugging.
#
# received - id: {id} rec: {"kind"=>"Test", "num"=>3, "link"=>"foo"}
#
# The response JSON should appear on stdout as:
#
# {"id":"abc","rec":{"kind":"Test","num":3,"link":"foo","wall":["I was here."]},"link":"foo"}
#
Piper::Actor::process() { |id,rec|
  $stderr.puts "received - id: {id} rec: #{rec}"
  
  rec['wall'] = [] if rec['wall'].nil?
  rec['wall'] << "I was here."

  Piper::Actor::ship(id, rec, rec['link'])
}
