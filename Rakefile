require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: :test
task test: %w[spec rubocop]

task readme: [] do
  `markdown README.md >README.html`
end
