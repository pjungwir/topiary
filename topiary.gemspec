lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'topiary/version'

Gem::Specification.new do |s|
  s.name = "topiary"
  s.version = Topiary::VERSION

  s.summary = "Topologically sorts a Directed Acyclic Graph."
  s.description = "Topologically sorts a Directed Acyclic Graph using Kahn's Algorithm. Lets you include some custom data on each node."

  s.authors = ["Paul A. Jungwirth"]
  s.homepage = "https://github.com/pjungwir/topiary"
  s.email = "pj@illuminatedcomputing.com"

  s.licenses = ["MIT"]

  s.require_paths = ["lib"]
  s.executables = []
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,fixtures}/*`.split("\n")

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rubocop'
end

