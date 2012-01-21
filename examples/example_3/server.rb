require "rubygems"
require "sinatra"
require "vworkapp_ruby"
require "json"
require "haml"

VW.api_key = "MY_API_KEY"

get '/' do
  @workers = VW::Worker.find
  haml :index
end

helpers do

  def job_json(workers)
    data = @workers.map do |w|
      next unless w.latest_telemetry

      jobs = VW::Job.find(:worker_id => w.id, :state => "started")

      jobs_html = jobs.inject("<h1 class='infobox'>ACTIVE JOBS:</h1>") do |str, job| 
        str << <<-EOL
          <div class="job">
            <span class="time">#{job.planned_start_at.strftime("%H:%M")}</span> #{job.customer_name}, #{job.template_name}
          </div>
        EOL
      end

      {
        :lat =>  w.latest_telemetry.lat, 
        :lng =>  w.latest_telemetry.lng, 
        :name => w.name,
        :jobs => jobs_html 
      }
    end
    
    data.to_json
  end

end