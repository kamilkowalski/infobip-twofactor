def api_key_response_body
  "\"fc6112a4559b5b44dafe5a943771b53b-020887ca-c56d-42c4-80b0-33a16ea23610\""
end

def api_send_pin_response
  %q{HTTP/1.1 200 OK
Server: Apache-Coyote/1.1
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, COPY, HEAD, OPTIONS, LINK, UNLINK, PURGE
Access-Control-Allow-Headers: Authorization, Content-Type
Content-Type: application/json;charset=UTF-8
Content-Length: 126
Date: Wed, 21 Jan 2015 13:58:15 GMT
Connection: close

{"pinId":"2B29B71922B37D3C93F8CEBB85B9E3CF","to":"48790809242","ncStatus":"NC_DESTINATION_UNKNOWN","smsStatus":"MESSAGE_SENT"}
}
end

def api_verify_pin_response
%q{HTTP/1.1 200 OK
Server: Apache-Coyote/1.1
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, COPY, HEAD, OPTIONS, LINK, UNLINK, PURGE
Access-Control-Allow-Headers: Authorization, Content-Type
Content-Type: application/json;charset=UTF-8
Content-Length: 105
Date: Wed, 21 Jan 2015 14:06:38 GMT
Connection: close

{"pinId":"2B29B71922B37D3C93F8CEBB85B9E3CF","msisdn":"48790809242","verified":true,"attemptsRemaining":0}
}
end

def api_verify_pin_failed_response
%q{HTTP/1.1 200 OK
Server: Apache-Coyote/1.1
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, COPY, HEAD, OPTIONS, LINK, UNLINK, PURGE
Access-Control-Allow-Headers: Authorization, Content-Type
Content-Type: application/json;charset=UTF-8
Content-Length: 129
Date: Wed, 21 Jan 2015 14:06:38 GMT
Connection: close

{"pinId":"1129B71922B37D3C93F8CEBB85B9E3CF","msisdn":"48790809242","verified":false,"attemptsRemaining":2}
}
end

def error_response
%q{HTTP/1.1 400 Bad Request
Server: Apache-Coyote/1.1
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, COPY, HEAD, OPTIONS, LINK, UNLINK, PURGE
Access-Control-Allow-Headers: Authorization, Content-Type
Content-Length: 96
Date: Thu, 22 Jan 2015 16:14:27 GMT
Connection: close

{"requestError":{"serviceException":{"messageId":"INVALID_ARGUMENT","text":"Invalid argument"}}}
}
end