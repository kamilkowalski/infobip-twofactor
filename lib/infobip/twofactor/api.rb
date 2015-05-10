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
        raise(ArgumentError, "Missing message_id") unless message_id
        raise(ArgumentError, "Missing application_id") unless application_id
        @message_id = message_id
        @application_id = application_id
        @url = url
        uri = URI.parse(@url + "/api-key")
        @http = Net::HTTP.new(uri.host, 443)
        @http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path)
        request.basic_auth(username, password)
        request["content-type"] = "application/json"
        @api_key = @http.request(request).body.gsub('"','')
      end

      def send_pin(phone)
        raise(ArgumentError, "Missing phone number") unless phone
        raise(ArgumentError, "Missing message_id") unless @message_id
        raise(ArgumentError, "Missing application_id") unless @application_id
        uri = URI.parse(@url + "/pin")
        request = Net::HTTP::Post.new(uri.path)
        request["authorization"] = "App #{@api_key}"
        request["content-type"] = "application/json"
        request.body = { applicationId: @application_id, messageId: @message_id, to: phone }.to_json
        response = @http.request(request)
        response_hash = JSON.parse(response.body)

        if response.code == "200"
          raise("Malformed API response - no smsStatus field. Response was: #{response_hash.inspect}") if response_hash["smsStatus"].nil?
          raise("Malformed API response - no pinId field. Response was: #{response_hash.inspect}") if response_hash["pinId"].nil?
          raise("SMS not sent") if response_hash["smsStatus"] == "MESSAGE_NOT_SENT"
          return response_hash
        else
          handle_error_response(response)
        end
      end

      def verify_pin(pin_id, pin)
        raise("Missing pin id") unless pin_id
        uri = URI.parse(@url + "/pin/#{pin_id}/verify")
        request = Net::HTTP::Post.new(uri.path)
        request["content-type"] = "application/json"
        request["authorization"] = "App #{@api_key}"
        request.body = { pin: pin }.to_json
        response = @http.request(request)
        response_hash = JSON.parse(response.body)

        if response.code == "200"
          raise "Malformed API response - no verified field. Response was: #{response_hash.inspect}" if response_hash["verified"].nil?
          return response_hash
        else
          handle_error_response(response)
        end
      end

      private
      def handle_error_response(response)
        case response.code
        when "400" then raise("Bad request")
        when "401" then raise("User unauthorized")
        when "404" then raise("Method not found")
        when "429" then raise("Too many requests to the API")
        when "500" then raise("Internal server error")
        when "503" then raise("Service unavailable")
        else
          raise("Unexpected response code: #{response.code}")
        end
      end
    end
  end
end
