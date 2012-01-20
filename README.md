# vWorkApp

This is a wrapper around vWorkApp's API. Go on! Use it!

    VWorkApp::Job.api_key = "MY_API_KEY"
    jobs = VWorkApp::Job.find(:worker_id => 1971, :state => "not_started")

## Todo

- Handle paging

- Broken API bits:
    * What's find(:search) for??. 
    * Why can't I filter by template?
    
- Missing job.actual_duration, job.actual_start_at

- Should have connivence method to lookup a customer from a job