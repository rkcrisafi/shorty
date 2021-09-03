# README

Welcome to Shorty App! :)

The URL shortener is written using the most familiar to me framework, Ruby on Rails.

To set it up, follow next steps:

(make sure to install ruby ($ ruby -v) and rails ($ rails -v) beforehand)

1. clone the repo
2. install the dependencies ($ bundle install)
3. run these commands:
    $ rails db:create
    $ rails db:migrate

4. run the server ($ rails s)
5. to test please use Rails console ($ rails c)
6. to run tests ($ rails tests)


I created 2 tables: urls and short_url_visits

Urls table is where we persist our newly created urls (long and short).
Short url visits is where a record is made every time request is being made to a short url. From this table, we are able to draw statistics as well.

Urls controller handles creation of new short links (POST '/urls') and redirecting short links to original URLs (GET '/gi93N2').

For custom Links, I chose to use only custom second halves since I am using only one domain.

Short url visits controller is responsible for delivering the stat data to users.

