$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')

# -------------
# Example 1: Create a job
# -------------

require "rubygems"
require "vworkapp_ruby"

MIN = 60

VWorkApp.api_key = "MY_API_KEY"

puts "vWorkApp - Create Job"
puts "---------------------"

job = VW::Job.new(
  "ACME Baking", 
  "Standard Booking",
  10 * MIN,
  [
    VW::Step.new("Start", VW::Location.new("880 Harrison St!", 37.779536, -122.401503)),
    VW::Step.new("End", VW::Location.from_address("201 1st Street, SF", :us))
  ],
  [
    VW::CustomField.new("Note", "Hi There!"),
  ]
)

puts "Job Created!. Check out the job in vWorkApp with id: #{job.create.id}"
