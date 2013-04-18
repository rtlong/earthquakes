# USGS Earthquakes JSON API

This is an extremely basic app which provides only a JSON API of [the USGS resource called 'Real-time, worldwide earthquake list for the past 7 days'][1]

[1]: https://explore.data.gov/Geography-and-Environment/Worldwide-M1-Earthquakes-Past-7-Days/7tag-iwnu

## API:

The API is a read-only collection resource &ndash; `earthquakes` &ndash; which responds to GET requests and accepts
the following optional parameters:

- `on` &ndash; expects a Unix timestamp, representing the entire day on which that timestamp occurs; restricts results to only those which took place on the specified day.
- `since` &ndash; expects a Unix timestamp; restricts results to only those which occurred after this time
- `over` &ndash; expects a decimal number representing a Richter magnitude (thus sensible values are 2.0&ndash;10.0); restricts results to only those which were measured higher than the specified magnitude
- `near` &ndash; expects a comma-separated pair of decimal numbers, representing a geographical location as latitude and longitude, respectively; restricts results to only those with epicenters within a 5-mile radius of the specified location

## EXAMPLES:

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

Note that if `on` and `since` are both specified, it will return results since the timestamp until the end of that day.

    GET /earthquakes.json?over=3.2&near=36.6702,-114.8870&since=1364582194
    # Returns all earthquakes over 3.2 magnitude within 5 miles of 36.6702,-114.8870 since 2013-03-29 18:36:34 UTC

    GET /earthquakes.json?over=3.2&on=1364582194&since=1364582194
    # Returns all earthquakes over 3.2 magnitude between 2013-03-29 18:36:34 UTC and 2013-03-29 23:59:59 UTC


## Why?

This was written for a code challenge; see [MANDATE.md](MANDATE.md)
