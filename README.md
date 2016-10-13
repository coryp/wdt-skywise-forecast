# WDT Skywise API
[![Code Climate](https://codeclimate.com/github/coryp/wdt-skywise-forecast/badges/gpa.svg)](https://codeclimate.com/github/coryp/wdt-skywise-forecast)
[![Gem Version](https://badge.fury.io/rb/wdt-skywise-forecast.svg)](https://badge.fury.io/rb/wdt-skywise-forecast)
[![Build Status](https://travis-ci.org/coryp/wdt-skywise-forecast.svg?branch=master)](https://travis-ci.org/coryp/wdt-skywise-forecast) 
[![Coverage Status](https://coveralls.io/repos/github/coryp/wdt-skywise-forecast/badge.svg?branch=master)](https://coveralls.io/github/coryp/wdt-skywise-forecast?branch=master)


Provides an easy-to-use wrapper for the WDT SkyWise Current and Forecast API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wdt-skywise-forecast'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wdt-skywise-forecast

## Usage

You will need your API credentials before you start.  Sign up for a demo account [here](https://skywise.wdtinc.com/signup?plan_ids[]=2357355853734 "here").

First configure your credientials and additional options in `config/initializers/wdt.rb`.


    Wdt::Skywise::Forecast::Client.app_id = '<your application id>'
    Wdt::Skywise::Forecast::Client.app_key = '<your application key>'
    Wdt::Skywise::Forecast::Client.units = '<us or all>'

Get weather data:

    wdt_client = Wdt::Skywise::Forecast::Client.new
    
    weather_data = wdt_client.weather_for(ZIP: '32128')
    
    weather_data.success            # => true
    weather_data.error              # => nil
    
    weather_data.response.present?  # => true

The full structure can be found [here](https://skywise.wdtinc.com/root/mega-docs.html#xml_response "here").

## Example

    wdt_client = Wdt::Skywise::Forecast::Client.new
    ret = wdt_client.weather_for(ZIP: '32128')
    
    if ret.success
        weather_data = ret.response
        
        weather_data.language                        # => "en"
        
        # location details
        weather_data.location["@attributes"].city    # => "Port Orange"
        weather_data.location["@attributes"].lat     # => "29.0905"
        
        # current conditions
        weather_data.location.sfc_ob.temp_F          # => "78"
        weather_data.location.sfc_ob.wx              # => "Mostly clear"
        weather_data.location.sfc_ob.moon_phase      # => "Waxing Gibbous Moon"
        
        # daily summaries
        weather_data.location.daily_summaries.daily_summary.count           # => 10
        weather_data.location.daily_summaries.daily_summary[0].max_temp_F   # => "82"
        weather_data.location.daily_summaries.daily_summary[0].wx           # => "Partly cloudy"
        
        # hourly summaries
        weather_data.location.hourly_summaries.hourly_summary.count         # => 240
        weather_data.location.hourly_summaries.hourly_summary[0].temp_F     # => "75"
        weather_data.location.hourly_summaries.hourly_summary[0].wx         # => "Rain showers"
    else
        puts ret.error
    end
    
    

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

