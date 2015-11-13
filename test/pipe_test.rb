#!/usr/bin/env ruby
# encoding: UTF-8

$VERBOSE = true

$: << File.join(File.dirname(File.dirname(File.expand_path(__FILE__))), 'lib')

require 'minitest'
require 'minitest/autorun'
require 'piper'
require 'oj'

$verbose = true

class PipeTest < Minitest::Test

  # Steps need to be done in order since they modify and then inspect the remote
  # piper cache.
  #
  # Before running the tests, start the connection_count sample in Piper Push
  # Cache. Piper Push Cache can be downloaded from piperpushcache.com. Follow
  # the instructions there to start the sample.
  def test_all
    man = Piper::Manager.new('localhost', 7661)
    iron = {
      'class' => 'Pipe',
      'id' => 'pipe-iron',
      'color' => 'gray',
      'hot-ok' => true
    }
    resp = man.push(iron['id'], iron);
    puts " PUT /#{iron['id']} response: #{resp.code} - #{resp.body}" if $verbose
    assert_equal(202, resp.code.to_i, 'expected a 202 when pushing iron')

    black = {
      'class' => 'Pipe',
      'id' => 'pipe-black',
      'color' => 'black',
      'hot-ok' => true
    }
    resp = man.push(black['id'], black);
    puts " PUT /#{black['id']} response: #{resp.code} - #{resp.body}" if $verbose
    assert_equal(202, resp.code.to_i, 'expected a 202 when pushing black')

    resp = man.get(iron['id']);
    puts " GET /#{iron['id']} response: #{resp.code} - #{resp.body}" if $verbose
    assert_equal(202, resp.code.to_i, 'expected a 202 when getting iron')

    resp = man.delete(iron['id']);
    puts " DELETE /#{iron['id']} response: #{resp.code} - #{resp.body}" if $verbose
    assert_equal(202, resp.code.to_i, 'expected a 202 when deleting iron')

    resp = man.get(iron['id']);
    puts " GET /#{iron['id']} response: #{resp.code} - #{resp.body}" if $verbose
    assert_equal(404, resp.code.to_i, 'expected a 404 when getting iron after delete')
    
    puts man.log(2, "what happens?")
    resp = man.get('foobar')
    puts " GET /foobar response: #{resp.code} - #{resp.body}"

    rid = man.info("Done with test.")
    resp = man.get(rid);
    puts " GET /#{rid} response: #{resp.code} - #{resp.body}" if $verbose
    assert_equal(202, resp.code.to_i, 'expected a 202 when getting #{rid} after logging')

  end

end
