# -------------
# Example: Create job
# -------------
# Imports a list of jobs from Google Docs and creates them in vWorkApp
# 

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require "rubygems"
require "vworkapp"

MIN = 60
HOUR = 60 * MIN

VWorkApp::Job.api_key = "AtuogECLCV2R7uT-fkPg"

puts <<-EOL
----------------------------
  vWorkApp - Create Job
----------------------------
EOL

job = VWorkApp::Job.new(
  "CUSTOMER !", 
  "MY TEMPLATE",
  10 * HOUR,
  [
    VWorkApp::Step.new("Start", VWorkApp::Location.new("880 Harrison St!", 37.779536, -122.401503)),
    VWorkApp::Step.new("End", VWorkApp::Location.new("880 Harrison St!", 37.779536, -122.401503)),
  ],
  [
    VWorkApp::CustomField.new("Note", "Hi There!"),
  ]
)
p job.create
