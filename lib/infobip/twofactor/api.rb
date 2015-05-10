require 'net/https'
require 'uri'
require 'json'

module Infobip
  module Twofactor

    API_HOST     = "oneapi.infobip.com"
    API_ENDPOINT = "/2fa/1"

    class API

      attr_reader :api_key
      attr_reader :application_id
      attr_reader :message_id

      def initialize(username, password, message_id, application_id)
        raise(ArgumentError, "Missing message_id") unless message_id
        raise(ArgumentError, "Missing application_id") unless application_id
        @message_id = message_id
        @application_id = application_id
        @http = Net::HTTP.new(API_HOST, 443)
        @http.use_ssl = true
        request = prepare_request(:post, "/api-key")
        request.basic_auth(username, password)
        @api_key = @http.request(request).body.gsub('"','')
      end

      def send_pin(phone)
        raise(ArgumentError, "Missing phone number") unless phone
        raise(ArgumentError, "Missing message_id") unless @message_id
        raise(ArgumentError, "Missing application_id") unless @application_id
        request = prepare_request(:post, "/pin", {
          applicationId: @application_id,
          messageId: @message_id,
          to: phone
        })
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
        raise("Missing pin ID") unless pin_id
        request = prepare_request(:post, "/pin/#{pin_id}/verify", { pin: pin })
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

      def prepare_request(method, path, body_hash = nil)
        class_name = "Net::HTTP::" + method.to_s.capitalize
        class_const = Module.const_get(class_name)
        request = class_const.new(API_ENDPOINT + path)
        request["Content-type"] = "application/json"

        unless @api_key.nil?
          request["Authorization"] = "App #{@api_key}"
        end

        unless body_hash.nil?
          request.body = body_hash.to_json
        end

        return request
      end
    end
  end
end
