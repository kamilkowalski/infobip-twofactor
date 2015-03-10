require 'spec_helper'
require 'yaml'
require 'fakeweb'

FakeWeb.allow_net_connect = false

describe Infobip::Twofactor::API do

  before do
    @configuration = YAML.load_file("configuration.yml")

    FakeWeb.register_uri(:post, "https://ippdok:4%40SkK2*_@oneapi.infobip.com/2fa/1/api-key",  status: ["200", "OK"], body: api_key_response_body)
    FakeWeb.register_uri(:post, "https://oneapi.infobip.com/2fa/1/pin",  response: api_send_pin_response)
    FakeWeb.register_uri(:post, "https://oneapi.infobip.com/2fa/1/pin/2B29B71922B37D3C93F8CEBB85B9E3CF/verify", response: api_verify_pin_response)
    @twofactor = Infobip::Twofactor::API.new(@configuration["username"], @configuration["password"], @configuration["url"], @configuration["message_id"], @configuration["application_id"])
  end

  subject { @twofactor }

  it "should return valid api key" do
    expect(subject.api_key.class).to eq String
    expect(subject.api_key.length).to eq 69
  end

  it "should create a valid Send PIN request, given valid params" do
    response = subject.send_pin("48790809242")
    expect(response["smsStatus"]).to eq "MESSAGE_SENT"
  end

  it "should create a valid Verify PIN request, given valid params" do
    response = subject.send_pin("48790809242")
    response = subject.verify_pin("2B29B71922B37D3C93F8CEBB85B9E3CF", "1234")
    expect(response["verified"]).to eq true
  end

  context "error handling" do

    it "new should raise an error when missing params"

    it "send pin should raise an error when missing params"

    it "verify pin should raise an error when missing params"

    it "should raise an error when received invalid response"

    it "should raise an error when received error object"

  end

end
