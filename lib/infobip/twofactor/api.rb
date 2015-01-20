require 'crib'
require 'base64'

module Infobip
  module Twofactor
    class API

      attr_reader :api_key
      # attr_reader :api
      # attr_reader :auth

      def initialize(username, password, url)
        #send auth reqest
        @authorization_string = Base64.strict_encode64("#{username}:#{password}")

        @auth = Crib.api(url) do |http|
          http.headers[:authorization] =  "Basic #{@authorization_string}"
        end

        #get and save api key
        @api_key = @auth.send("api-key")._post.gsub('"','')
        @api = Crib.api(url) do |http|
          http.headers[:authorization]  = "App #{@api_key}"
          http.headers["content-type"] = "application/json"
        end

      end


      def send_pin(application_id, message_id, phone)
        @api.pin._post(applicationId: application_id, messageId: message_id, to: phone)
      end

      def verify_pin(pin_id, pin)
        @api.pin(pin_id).verify._post(pin: pin)
      end

    end
  end
end
