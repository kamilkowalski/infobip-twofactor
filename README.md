[![Build Status](https://travis-ci.org/visualitypl/infobip-twofactor.svg?branch=master)](https://travis-ci.org/visualitypl/infobip-twofactor.svg?branch=master)



# Infobip::Twofactor

Simple wrapper gem for Infobip two factor authentication service

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'infobip-twofactor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install infobip-twofactor

## Usage

```ruby
require 'infobip/twofactor'
@twofactor = Infobip::Twofactor::API.new("username", "password", "http://oneapi-test.infobip.com/2fa/1")

 => #<Infobip::Twofactor::API:0x007fcce1e7efe0 @authorization_string="aXBwZG9rOjRAU2tLMipf", @auth=#<Crib::API:0x007fcce1e7ee78 @_agent=<Sawyer::Agent http://oneapi-test.infobip.com/2fa/1>, @_last_response=#<Sawyer::Response: 200 @rels={} @data="\"d02f4d9a2d9fb5a70b827819823254b8-9d48e592-db4a-4a70-95f0-59b5a49f48d4\"">>, @api_key="d02f4d9a2d9fb5a70b827819823254b8-9d48e592-db4a-4a70-95f0-59b5a49f4edd4", @api=#<Crib::API:0x007fcce1f8c0b8 @_agent=<Sawyer::Agent http://oneapi-test.infobip.com/2fa/1>>>

@twofactor.send_pin("application_id","message_id", "phone")

 => {:pinId=>"C2390DD39E0E1E39252D34BE796885FD", :to=>"48790409242", :ncStatus=>"NC_DESTINATION_UNKNOWN", :smsStatus=>"MESSAGE_SENT"}

@twofactor.verify_pin("C2390DD39E0E1E39252D34BE796885FD", "pin")

 => {:pinId=>"C2390DD39E0E1EA9252D34BE796885FD", :msisdn=>"48790809242", :verified=>true, :attemptsRemaining=>0}

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/infobip-twofactor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
