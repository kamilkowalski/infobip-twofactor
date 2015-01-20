require 'spec_helper'
require 'yaml'
require 'fakeweb'

FakeWeb.allow_net_connect = false

describe Infobip::Twofactor::API do

  before do
    @configuration = YAML.load_file("configuration.yml")
    FakeWeb.register_uri(:post, "http://ippdok:4%40SkK2*_@oneapi-test.infobip.com/2fa/1/api-key",  status: ["200", "OK"], body: api_key_response_body)
    FakeWeb.register_uri(:post, "http://oneapi-test.infobip.com/2fa/1/pin",  status: ["200", "OK"], body: api_send_pin_response_body)
    FakeWeb.register_uri(:post, "http://oneapi-test.infobip.com/2fa/1/pin/C6634467BFDB5E0BDCC1408B5315E84A/verify", status: ["200", "OK"], body: api_verify_pin_response_body)
    @twofactor = Infobip::Twofactor::API.new(@configuration["username"], @configuration["password"], @configuration["url"])
  end

  subject { @twofactor }

  it "should return valid api key" do
    expect(@twofactor.api_key.class).to eq String
    expect(@twofactor.api_key.length).to eq 69
  end

  it "should create a valid Send PIN request, given valid params" do
    response = @twofactor.send_pin(@configuration["application_id"], @configuration["message_id"], "48790809242")
    if response.class == String
      response_hash = eval(response)
    else
      response_hash = response
    end
    expect(response_hash[:smsStatus]).to eq "MESSAGE_SENT"
  end

  it "should create a valid Verify PIN request, given valid params" do
    response = @twofactor.verify_pin("C6634467BFDB5E0BDCC1408B5315E84A", "1234")
    if response.class == String
      response_hash = eval(response)
    else
      response_hash = response
    end
    expect(response_hash[:verified]).to eq "true"
  end

end


#      FakeWeb.register_uri(:post, "https://apitest.authorize.net/xml/v1/request.api",  status: ["200", "OK"], body: successful_purchase_response)
 #     request = Hash.from_xml(FakeWeb.last_request.body.gsub("\n", ""))["createTransactionRequest"]["transactionRequest"]
