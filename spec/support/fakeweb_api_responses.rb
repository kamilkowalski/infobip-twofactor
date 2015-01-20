def api_key_response_body
  "\"fc6112a4559b5b44dafe5a943771b53b-020887ca-c56d-42c4-80b0-33a16ea23610\""
end

def api_send_pin_response_body
  '{pinId: "2B29B71922B37D3C93F8CEBB85B9E3CF", to: "48790809242", ncStatus: "NC_DESTINATION_UNKNOWN", smsStatus: "MESSAGE_SENT"}'
end

def api_verify_pin_response_body
  '{pinId: "0099939F5D1FC903B8A8A3990E452892",msisdn: "48790809242", verified: "true", attemptsRemaining: "0"}'
end