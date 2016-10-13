require "wdt/skywise/forecast/version"
require 'httparty'

module Wdt
  module Skywise
    module Forecast

      class Response
        attr_accessor :response, :success, :error

        def initialize(options)
          @response = options[:response]
          @success = options[:success]
          @error = options[:error]
        end
      end

      class Client

        include HTTParty
        base_uri "https://skywisefeeds.wdtinc.com"

        class << self
          attr_accessor :app_id, :app_key, :format, :units
        end

        def self.base_url
          "https://skywisefeeds.wdtinc.com/feeds/api/mega.php"
        end

        def weather_for(options)
          # validate parameter combinations
          valid = validate_options(options)
          if !valid[:success]
            return Wdt::Skywise::Forecast::Response.new({error: valid[:error], success: valid[:success]} )
          end

          # set format and units defaults
          options[:FORMAT] = "json"
          options[:UNITS] = Wdt::Skywise::Forecast::Client.units || "us"
          response = self.class.get("/feeds/api/mega.php", query: options, headers: auth)

          # make the API call
          if response.code == 200
            response_body = JSON.parse(response.body, object_class: OpenStruct)
            return Wdt::Skywise::Forecast::Response.new({response: response_body, success: true} )
          elsif response.code == 403
            return Wdt::Skywise::Forecast::Response.new({error: "Not Authorized", success: false} )
          end

        end

        private
        def validate_options(options)
          if options.empty?
            error = "No parameters specified"
            success = false
          elsif options.has_key?(:CITY) && ( !options.has_key?(:STATE) && !options.has_key?(:COUNTRY))
            error = "STATE or COUNTRY must be provided with CITY"
            success = false
          elsif options.has_key?(:LAT) && !options.has_key?(:LONG)
            error = "LONG must be provided with LAT"
            success = false
          elsif options.has_key?(:LONG) && !options.has_key?(:LAT)
            error = "LAT must be provided with LONG"
            success = false
          else
            success = true
          end
          {error: error, success: success}
        end

        def auth
          {app_id: Wdt::Skywise::Forecast::Client.app_id, app_key: Wdt::Skywise::Forecast::Client.app_key}
        end
      end  
    end
  end
end
