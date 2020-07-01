module Piwik
  class Segment < Base
    class << self
      def collection
        Piwik::SegmentEditor
      end
      def id_attr
        :idSegment
      end
    end

  end
end
