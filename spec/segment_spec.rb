require 'spec_helper'
describe Piwik::Segment do
  before {
    stub_api_calls
  }

  subject { build(:segment) }

  its(:idsegment) { should eq 5 }
  its(:name) { should eq 'Custom Segment Five' }
  its(:definition) { should eq 'referrerType==website' }
  its(:login) { should eq 'john.doe' }
  its(:enable_all_users) { should eq 0 }
  its(:enable_only_idsite) { should eq 1 }
  its(:auto_archive) { should eq 0 }
  its(:ts_created) { should eq '2020-06-17 18:16:26' }
  its(:ts_last_edit) { should eq '2020-06-18 19:08:26' }
  its(:deleted) { should eq 0 }

  it {
    subject.save.should eq true
    subject.definition = 'referrerType=search'
    subject.update.should eq true
    subject.destroy.should eq true
  }
end
