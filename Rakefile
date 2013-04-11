require 'rake/testtask'
require 'bundler/gem_tasks'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb', 'spec/**/*_spec.rb']
  t.warning = true
end

task :default => :test