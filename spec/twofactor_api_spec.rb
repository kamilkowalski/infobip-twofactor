require 'spec_helper'
require 'yaml'


describe Infobip::Twofactor::API do

  before do
    configuration = YAML.load_file("configuration.yml")
    @twofactor = Infobip::Twofactor::API.new(configuration["username"], configuration["password"], configuration["url"])
  end

  subject { @twofactor }

  it "should return valid api key" do
    expect(@twofactor.api_key.class).to eq String
    expect(@twofactor.api_key.length).to eq 71
  end

  it "should create a valid Send PIN request, given valid params" do
    pending "Implementation"
    fail
  end

  it "should create a valid Verify PIN request, given valid params" do
    pending "Implementation"
    fail
  end

end