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
  :customer_name => "ACME Baking", 
  :template_name => "Standard Booking",
  :planned_duration => 10 * MIN,
  :steps => [
    {:name => "Start", :location => {:formatted_address => "880 Harrison St, SF, USA", :lat => 37.779536, :lng => -122.401503}},
    {:name => "End", :location => VW::Location.from_address("201 1st Street, SF", :us).attributes}
  ],
  :custom_fields => [
    :name => "Note", :value => "Hi There!"
  ]
)

job = job.create

puts "Job Created!. Check out the job in vWorkApp with id: #{job.id}"
