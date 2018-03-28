require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task readme: [] do
  `markdown README.md >README.html`
end

if ENV['CI'].nil?
  task default: %w[spec rubocop]
else
  case ENV['SUITE']
  when 'rubocop' then task default: :rubocop
  else                task default: :spec
  end
end
