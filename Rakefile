require "bundler/gem_tasks"

task :suite do
  if system("rspec spec")
    puts "Test suite passed!!"
  else
    puts "Test suite failed..."
    exit(1)
  end
end

task :default => :suite
