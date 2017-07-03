require "bundler/gem_tasks"
require 'rspec/core/rake_task'

task :default => :test

RSpec::Core::RakeTask.new(:spec)

desc "Test the stub test orchestrator"
task :test => :spec do
  ENV["TEST_ORCHESTRATION_PROVIDER"] ||= "stub"
  sh %{bundle exec cucumber}
end

namespace :test do
  desc "Test includes"
  task :includes do
    Dir.chdir("lib") do
      Dir["**/*.rb"].map { |x| x.chomp(".rb") }.each do |f|
        sh %Q{ruby -e '$LOAD_PATH.unshift("."); require "#{f}"; exit 0'}
      end
    end
  end
end
