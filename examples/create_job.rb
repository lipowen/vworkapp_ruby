# -------------
# Example: Create job
# -------------
# Imports a list of jobs from Google Docs and creates them in vWorkApp
# 

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require "rubygems"
require "vworkapp_ruby"

MIN = 60
HOUR = 60 * MIN

VWorkApp.api_key = "AtuogECLCV2R7uT-fkPg"

puts <<-EOL
----------------------------
  vWorkApp - Create Job
----------------------------
EOL

job = VWorkApp::Job.new(
  "ACME Inc.", 
  "Standard Booking",
  10 * HOUR,
  [
    VWorkApp::Step.new("End", VWorkApp::Location.from_address("201 1st Street, SF", :us)),
    VWorkApp::Step.new("Start", VWorkApp::Location.new("880 Harrison St!", 37.779536, -122.401503))
  ],
  [
    VWorkApp::CustomField.new("Note", "Hi There!"),
  ]
)
p job.create
