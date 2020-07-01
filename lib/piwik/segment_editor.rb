module Piwik
  class SegmentEditor < ApiModule
    available_methods %W{
      get
      getAll
      add
      update
      delete
      isUserCanAddNewSegment
    }

    def self.get params
      response = self.api_call('get', params)
      raise Piwik::UnknownSegment if response.== '0'
      Piwik::Segment.new response
    end

    def self.add params
      segment = Piwik::Segment.new(params)
      response = self.api_call('add', params)
      segment.attributes.idSegment = response
      segment
    end

    def self.save params
      self.api_call('update',params)
    end

    def self.delete params
      self.api_call('delete', params)
    end
  end
end
