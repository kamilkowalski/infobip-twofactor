require 'crib'
require 'base64'

module Infobip
  module Twofactor
    class API

      attr_reader :api_key

      def initialize(username, password, url)
        #send auth reqest

        @auth = Base64.strict_encode64("#{username}:#{password}")
        @api = Crib.api(url) do |http|
          http.authorization 'Basic', @auth
        end

        #get and save api key
        @api_key = @api.send("api-key")._post

      end


      def send_pin(application_id, message_id, phone)
      end

      def verify_pin
      end

    end
  end
end
