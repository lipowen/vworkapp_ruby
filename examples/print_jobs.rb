# -------------
# Example: Print Jobs
# -------------
# Gets all workers, and then prints a list of each's unstarted jobs to the terminal.
# 

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require "vworkapp"

VWorkApp::Job.api_key = "AtuogECLCV2R7uT-fkPg"

puts <<-EOL
----------------------------
  vWorkApp - List of jobs
----------------------------
EOL
workers = VWorkApp::Worker.all
workers.each do |worker|
  puts "Worker: #{worker["name"]}"  
  jobs = VWorkApp::Job.find(:worker_id => worker["id"], :state => "not_started")
  jobs.each do |job|
    puts "\t #{job["id"]}, #{job["customer_name"]}, #{job["template_name"]}"
    p job
  end
  puts ""
end
