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
  
You can create a job in vWorkApp: 

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
    job.create

Search for jobs:

    jobs = VW::Job.find(:state => "not_started")
    jobs.each { |job| puts job.customer_name }

Update jobs:

    job = VW::Job.find(101) # assuming a job with this ID exists already
    job.steps.first.location = VW::Location.from_address("101 1st Street, SF", :us)
    job.update

And delete them:

    job = VW::Job.find(101) # assuming a job with this ID exists already
    job.delete

Full documentation on the API can be found [here](http://api.vworkapp.com/api/).

## Future Work / Improvements

- The wrapper doesn't handle paging of search results yet.

- Proof-of-delivery needs to be added.

- Base classes could be refactored out into their own gem and made a little more generic.

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
