require 'rake/testtask'
 
Rake::TestTask.new do |task|
  task.libs << %w(test lib)
  task.pattern = 'test/**/*_test.rb'
end
 
task :default => :test