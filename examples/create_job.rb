# -------------
# Example: Create job
# -------------
# Imports a list of jobs from Google Docs and creates them in vWorkApp
# 

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require "vworkapp"

VWorkApp::Job.api_key = "AtuogECLCV2R7uT-fkPg"

puts <<-EOL
----------------------------
  vWorkApp - Create Job
----------------------------
EOL
p VWorkApp::Job.create(:customer_name => "customer_test", 
                       :template_name => "template_test", 
                       :steps => 
                       [
                         {
                           :name => "Start", 
                           :location =>{:lng => -0.1223997116E3, :lat => 0.377877592E2, :formatted_address=> "101 2nd St, San Francisco, CA 94105, USA"}
                         },
                         {
                           :name => "End", 
                           :location =>{:lng => -0.1223997116E3, :lat => 0.377877592E2, :formatted_address=> "101 2nd St, San Francisco, CA 94105, USA"}
                         }
                       ]#,
                       #:planned_duration=>7200
                     )

