require 'net/https'
require 'uri'
require 'json'

module Infobip
  module Twofactor
    class API

      attr_reader :api_key
      attr_reader :application_id
      attr_reader :message_id

      def initialize(username, password, url, message_id, application_id)
        raise "Missing message_id" unless message_id
        raise "Missing application_id" unless application_id
        @message_id = message_id
        @application_id = application_id
        @url = url
        uri = URI.parse(@url+"/api-key")
        @http = Net::HTTP.new(uri.host, 443)
        @http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path)
        request.basic_auth(username,password)
        request["content-type"] = "application/json"
        @api_key = @http.request(request).body.gsub('"','')
      end

      def send_pin(phone)
        raise "Missing phone number" unless phone
        raise "Missing message_id" unless @message_id
        raise "Missing application_id" unless @application_id
        uri = URI.parse(@url+"/pin")
        request = Net::HTTP::Post.new(uri.path)
        request["authorization"] = "App #{@api_key}"
        request["content-type"] = "application/json"
        request.body = {applicationId: @application_id, messageId: @message_id, to: phone}.to_json
        response = JSON.parse @http.request(request).body
        raise "Malformed two factor API response - no sms status field. Response was: #{response.inspect}" if (response["smsStatus"].nil?)
        raise "Malformed two factor API response - no pin Id field. Response was: #{response.inspect}" if (response["pinId"].nil?)
        raise "SMS not sent" unless (response["smsStatus"] == "MESSAGE_SENT")
        @pin_id = response["pinId"]
        response
      end

      def verify_pin(pin_id, pin)
        raise "Missing pin id" unless pin_id
        uri = URI.parse(@url+"/pin/#{pin_id}/verify")
        request = Net::HTTP::Post.new(uri.path)
        request["content-type"] = "application/json"
        request["authorization"] = "App #{@api_key}"
        request.body = {pin: pin}.to_json
        response = JSON.parse @http.request(request).body
        raise "Malformed two factor API response - no verified field. Response was: #{response.inspect}" if (response["verified"].nil?)
        response
      end

    end
  end
end
