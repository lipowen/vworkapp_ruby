# Example 3: Worker Map

This example creates a web server on your local computer that shows the location of each vWorkApp worker on a map, along with  

## Installation and Usage

If you aren't already using bundler, install it here:

    sudo gem install bundler
  
Then run:

    bundle install
    ruby server

Open <code>server.rb</code> and replace MY\_API\_KEY with your own vWorkApp API Key. 

    VW.api_key = "MY_API_KEY"

Finally, open your web browser and go to:

    http://localhost:4567
