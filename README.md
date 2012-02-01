# vWorkApp API's Ruby Wrapper

This is a ruby wrapper around vWorkApp's developer API. You can use it to create, find, update, and delete vWorkApp's jobs, customers, and users from your account.

Although vWorkApp's API can be accessed directly through HTTP+XML this wrapper makes it easier and quicker for ruby developers to dive into using vWorkApp's API.

## Installation

    gem install vworkapp_ruby

Or if you're using a Gemfile, include the following line:

    gem 'vworkapp_ruby'

## Usage

Before you use the API you need to specify your API Key. If you don't have an API Key then contact support@vworkapp.com to be given one.

    VW.api_key = "MY_API_KEY"
  
You can create a vWorkApp job: 

    job = VW::Job.new(
      "ACME Baking", "Standard Booking", 120,
      [
        VW::Step.new("Start", VW::Location.from_address("201 1st Street, SF", :us)),
        VW::Step.new("End",   VW::Location.new("880 Harrison St!", 37.779536, -122.401503))
      ],
      [
        VW::CustomField.new("Note", "Watch out for the really big dog!")
      ]
    )
    job.create

And update it:

    job = VW::Job.find(101) # assuming a job with this ID exists already
    job.steps.first.location = VW::Location.from_address("101 1st Street, SF", :us)
    job.update

Then delete it:

    job = VW::Job.find(101) # assuming a job with this ID exists already
    job.delete

Full documentation on the API can be found [here](http://api.vworkapp.com/api/).

## Todo

- Handle paging.

- Broken in the API itself:
    * Worker should become Users
    * Job.worker_id should become Job.assigned_to_id
    * Why can't I filter by template?
    * Returning 404s on show
    * What's the point posting pubished_at? And why does it need to be present when assigning a job? 
    * Delivery Contact should be called SiteContact
    * Errors suck: When you try to post a job without a published_at you get:
        <errors>
          <error>must exist for allocated/assigned jobs.</error>
        </errors>

    * Should "STATE" be called assign_state instead?      
        ASSIGNED_STATE_UNALLOCATED = 'unallocated'
        ASSIGNED_STATE_ALLOCATED = 'allocated'
        ASSIGNED_STATE_ASSIGNED = 'assigned'
        ASSIGNED_STATE_DELETED = 'deleted'

        PROGRESS_STATE_NOT_STARTED = 'not_started'
        PROGRESS_STATE_STARTED  = 'started'
        PROGRESS_STATE_COMPLETED = 'completed'

    * Can't pass a telemetry update to a worker. Maybe API should support this? 

    * Can't pass a telemetry update to a worker. Maybe API should support this? 

    * This POST fails because of the nil contacts. Gives a "undefined method `with_indifferent_access' for nil:NilClass" error. Really should just be ignored instead.
    
        <customer> 
          <name>Joe's Baked Goods</name> 
          <third-party-id nil="true" /> 
          <id nil="true" /> 
          <billing-contact nil="true" /> 
          <delivery-contact nil="true" /> 
        </customer>

    * This POST fails because of the nil custom fields element. Really should just be ignored instead.

        <job> 
          <steps type="array"> 
            <step> 
              <name>Start</name> 
              <completed-at nil="true" /> 
              <location> 
                <lng type="float">-122.401503</lng> 
                <lat type="float">37.779536</lat> 
                <formatted-address>880 Harrison St</formatted-address> 
              </location> 
            </step> 
          </steps> 
          <planned-start-at nil="true" /> 
          <customer-name>Joe</customer-name> 
          <template-name>Std Delivery</template-name> 
          <planned-duration type="integer">60</planned-duration> 
          <custom-fields nil="true" /> 
        </job>


      * How do we handle updates that don't include all elements? Should it set the element to nil? Or should it ignore the element? This is where I see some companies using the new HTTP verb PATCH now. 

    
- Missing:
  * job.actual_duration, 
  * job.actual_start_at
  * job.status (and progress state??)

- Missing POD resource

- Should have connivence method to lookup a customer from a job

## License

This API wrapper is published under the MIT License.

    Copyright (C) 2012 vWorkApp Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
    of the Software, and to permit persons to whom the Software is furnished to do
    so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
