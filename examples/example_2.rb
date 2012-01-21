$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')

# -------------
# Example 2: Print each worker's jobs
# -------------

require "rubygems"
require "vworkapp_ruby"

VW.api_key = "MY_API_KEY"

puts "vWorkApp - List of jobs"
puts "----------------------------"

workers = VW::Worker.find

workers.each do |worker|
  puts "Worker: #{worker.name}"
  jobs = VW::Job.find(:worker_id => worker.id, :state => "not_started")
  jobs.each do |job|
    puts "\t #{job.third_party_id || job.id}, #{job.customer_name}, #{job.template_name}"
  end
  puts "----------------------------"
end
