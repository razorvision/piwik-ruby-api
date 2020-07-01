require 'spec_helper'
describe 'Piwik::SegmentEditor' do
  before {
    stub_api_calls
  }

  let(:params) { {:idSite => 1, :period => 'day', :date => 'yesterday'} }
  subject { Piwik::SegmentEditor }

  describe "#get" do
    it { subject.get(params).should be_a Piwik::Segment }
  end

  it "#getAll"
  it "#add"
  it "#update"
  it "#delete"
  it "#isUserCanAddNewSegment"
end
