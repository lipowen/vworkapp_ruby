# Example 3: Worker Map

This example creates a web server on your local computer that shows the location of each vWorkApp worker on a map, along with  

## Installation and Usage

If you aren't already using bundler, install it here:

    sudo gem install bundler
  
Open <code>server.rb</code> and replace MY\_API\_KEY with your own vWorkApp API Key. 

    VW.api_key = "MY_API_KEY"

And open <code>/views/index.haml</code> and replace MY\_GOOGLE\_API\_KEY with your own Google API Key. If you don't have one it can be obtained here: http://code.google.com/apis/maps/signup.html  

    %script{:src => "http://maps.googleapis.com/maps/api/js?key=MY_GOOGLE_API_KEY&sensor=false", :type => "text/javascript"}

Then run:

    bundle install
    ruby server

Finally, open your web browser and go to:

    http://localhost:4567
