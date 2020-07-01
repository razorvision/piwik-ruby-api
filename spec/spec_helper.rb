require 'rspec/its'
require 'piwik'

RSpec.configure do |config|
  Dir[File.join(File.dirname(__FILE__),'spec','support''**','*.rb')].each {|f| require f}
  config.mock_with :rspec
  config.order = "random"
end

def stub_rails_env &block
  Object.const_set("RAILS_ROOT", File.join(File.dirname(__FILE__),"files"))
  yield
  Object.const_set("RAILS_ROOT",nil)
end

def success_response
  File.join(File.dirname(__FILE__),'files',"success.xml")
end

def failure_response
  File.join(File.dirname(__FILE__),'files',"failure.xml")
end

def stub_api_calls
  # Stubbing the main API call method. Methods without a specific stub
  # will always return a success response
  Piwik::Base.stub(:call) do |method,params,piwik_url,auth_token|
    resp_file = File.join(File.dirname(__FILE__),'files',"#{method}.xml")
    xml = if File.exists?(resp_file)
      File.binread resp_file
    else
      File.binread File.join(success_response)
    end
    if xml.is_a?(String) && xml.force_encoding('BINARY').is_binary_data?
      xml.force_encoding('BINARY')
    elsif xml =~ /error message=/
      result = XmlSimple.xml_in(xml, {'ForceArray' => false})
      raise Piwik::ApiError, result['error']['message'] if result['error']
    else
      xml
    end
  end
end

def assert_data_integrity method, options = {}
  it { puts subject.inspect } if options[:debug]
  it { expect { subject.send(method,params) }.not_to raise_error }
  enum_class = defined?(Enumerator) ? 'Enumerator' : 'Enumerable::Enumerator'
  it { subject.send(method,params).each.should be_a(enum_class.constantize) }
  it { subject.send(method,params).empty?.should eq(false) }
  if options[:size].present?
    it { subject.send(method,params).size.should eq(options[:size]) }
  end
end

def assert_value_integrity method, options = {}
  it { puts subject.inspect } if options[:debug]
  it { expect { subject.send(method,params) }.not_to raise_error }
  it { subject.send(method,params).empty?.should eq(false) }
  if options[:value].present?
    it { subject.send(method,params).value.should eq(options[:value]) }
  end
end

def build(object, attrs = {})
  case object
  when :user
    def_attrs = { :login => "test_user", :password => "changeme", :email => "user@test.local", :user_alias => "Test User" }
    Piwik::User.new(def_attrs.merge(attrs))
  when :site
    def_attrs = { :idsite => 1, :main_url => "http://test.local", :name => "Test Site" }
    Piwik::Site.new(def_attrs.merge(attrs))
  when :segment
    def_attrs = { idsegment: 5, name: "Custom Segment Five",
                  definition: "referrerType==website", login: "john.doe",
                  enable_all_users: 0, enable_only_idsite: 1, auto_archive: 0,
                  ts_created: "2020-06-17 18:16:26",
                  ts_last_edit: "2020-06-18 19:08:26", deleted: 0 }
    Piwik::Segment.new(def_attrs.merge(attrs))
  end
end

PIWIK_URL = 'http://piwik.local'
PIWIK_TOKEN = '90871c8584ddf2265f54553a305b6ae1'
