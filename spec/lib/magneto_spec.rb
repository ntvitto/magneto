require 'spec_helper'


describe Magneto::Session do
  it 'should raise error if api_user, api_key and at least one wsdl are not present' do
    lambda { Magneto::Session.new() }.should raise_error(Magneto::ConfigError)
  end
end

describe Magneto::Session do

  before do
    Magneto.configure do |config|
      config.api_user = 'foo'
      config.api_key = 'bar'
      config.wsdl_v1 = 'http://www.example.com/wdsl'
    end
  end

  describe '.logged' do
    it 'should return true if log in succeed' do
      success = {:login_response=>{:login_return=>"7ab1f29cd18ac06f309c89ba96517ada"}}
      Savon::Client.any_instance.should_receive(:request).with(:login).and_return success
      session = Magneto::Session.new
      session.should be_a Magneto::Session
      session.login()
      session.logged.should be true
    end

    it 'should return false if log in succeed' do
      failed = {:fault => {:faultcode => "2", :faultstring => "Access denied."}}
      Savon::Client.any_instance.should_receive(:request).with(:login).and_return failed
      session = Magneto::Session.new
      session.should be_a Magneto::Session
      session.login()
      session.logged.should be false
    end
  end
  describe '.session_token' do
    it 'should return session token' do
      success = {:login_response=>{:login_return=>"7ab1f29cd18ac06f309c89ba96517ada"}}
      Savon::Client.any_instance.should_receive(:request).with(:login).and_return success
      session = Magneto::Session.new
      session.login()
      session.session_token.should eq '7ab1f29cd18ac06f309c89ba96517ada'
    end
  end
end
