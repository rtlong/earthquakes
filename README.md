# Coding Challenge

Create an JSON API to the "Real-time, worldwide earthquake list for the past 7 days".

    https://explore.data.gov/Geography-and-Environment/Worldwide-M1-Earthquakes-Past-7-Days/7tag-iwnu
    http://earthquake.usgs.gov/earthquakes/catalogs/eqs7day-M1.txt


### 1. Write a rake task to download the latest CSV of earthquakes and import it into a suitable database.

This rake task should be idempotent. It should only import records that haven't been imported already. Ideally this task would run
once a minute to import the latest earthquakes.

### 2. Write a HTTP JSON API for this data

    GET /earthquakes.json
    # Returns all earthquakes

    GET /earthquakes.json?on=1364582194
    # Returns earthquakes on the same day (UTC) as the unix timestamp 1364582194

    GET /earthquakes.json?since=1364582194
    # Returns earthquakes since the unix timestamp 1364582194

    GET /earthquakes.json?over=3.2
    # Returns earthquakes > 3.2 magnitude

    GET /earthquakes.json?near=36.6702,-114.8870
    # Returns all earthquakes within 5 miles of lat: 36.6702, lng: -114.8870

    NOTES:
    
    The endpoint should be able to take any combination of GET params, and
    filter the results properly. If on and since are both present, it should
    return results since the timestamp until the end of that day.
    
    EXAMPLES:
    
    GET /earthquakes.json?over=3.2&near=36.6702,-114.8870&since=1364582194
    # Returns all earthquakes over 3.2 magnitude within 5 miles of 36.6702,-114.8870 since 2013-03-29 18:36:34 UTC

    GET /earthquakes.json?over=3.2&on=1364582194&since=1364582194
    # Returns all earthquakes over 3.2 magnitude between 2013-03-29 18:36:34 UTC and 2013-03-29 23:59:59 UTC

### 3. Write tests/specs in your preferred test library

Both the API and import task should be tested.

### Bonus

Bonus points if open sourced on github and running on heroku. Also feel free to
add any additional features you think would be interesting or cool. Be creative; don't
be afraid to show off!