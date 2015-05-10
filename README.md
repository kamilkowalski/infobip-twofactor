[![Build Status](https://travis-ci.org/visualitypl/infobip-twofactor.svg?branch=master)](https://travis-ci.org/visualitypl/infobip-twofactor.svg?branch=master)

[![Gem Version](https://badge.fury.io/rb/infobip-twofactor.svg)](http://badge.fury.io/rb/infobip-twofactor)

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
@twofactor = Infobip::Twofactor::API.new("username", "password", "message_id", "application_id")

@twofactor.send_pin("phone")

 => {:pinId=>"C2390DD39E0E1E39252D34BE796885FD", :to=>"48738288288", :ncStatus=>"NC_DESTINATION_UNKNOWN", :smsStatus=>"MESSAGE_SENT"}

@twofactor.verify_pin("pin")

 => {:pinId=>"C2390DD39E0E1EA9252D34BE796885FD", :msisdn=>"48738288288", :verified=>true, :attemptsRemaining=>0}

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/infobip-twofactor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
