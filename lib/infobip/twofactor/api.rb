require 'crib'
require 'base64'

module Infobip
  module Twofactor
    class API

      attr_reader :api_key
      attr_reader :pin_id
      attr_reader :application_id
      attr_reader :message_id

      def initialize(username, password, url, message_id, application_id)
        raise "Missing message_id" unless message_id
        raise "Missing application_id" unless application_id
        #send auth reqest
        @authorization_string = Base64.strict_encode64("#{username}:#{password}")
        @message_id = message_id
        @application_id = application_id

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


      def send_pin(phone)
        raise "Missing phone number" unless phone
        raise "Missing message_id" unless @message_id
        raise "Missing application_id" unless @application_id
        response = @api.pin._post(applicationId: @application_id, messageId: @message_id, to: phone)
        raise "Malformed two factor API response - no sms status field" unless (response.respond_to?(:smsStatus))
        raise "Malformed two factor API response - no pin Id field" unless (response.respond_to?(:pinId))
        raise "SMS not sent" unless (response.smsStatus == "MESSAGE_SENT")
        @pin_id = response[:pinId]
        response
      end

      def verify_pin(pin)
        raise "Missing pin id" unless @pin_id
        response = @api.pin(@pin_id).verify._post(pin: pin)
        raise "Malformed two factor API response - no verified field" unless (response.respond_to?(:verified))
        response
      end

    end
  end
end
