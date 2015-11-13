
require 'date'
require File.join(File.dirname(__FILE__), 'lib/piper/version')

Gem::Specification.new do |s|
  s.name = "piper-ruby"
  s.version = ::Piper::VERSION
  s.authors = "Peter Ohler"
  s.date = Date.today.to_s
  s.email = "peter@ohler.com"
  s.homepage = "http://www.piperpushcache.com"
  s.summary = "Management client for Piper Push Cache."
  s.description = %{A Ruby management client to push JSON to Piper Push Cache.}
  s.licenses = ['MIT']

  s.files = Dir["{lib,test}/**/*.{rb}"] + ['LICENSE', 'README.md']

  s.require_paths = ["lib"]

  s.has_rdoc = true
  s.extra_rdoc_files = ['README.md']
  s.rdoc_options = ['--main', 'README.md']
  
  s.rubyforge_project = 'piper-ruby'
end
