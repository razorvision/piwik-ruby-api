module Piwik
  class ScheduledReports < ApiModule
    available_methods %W{
      addReport
      updateReport
      deleteReport
      getReports
      generateReport
      sendReport
    }
    
    
  end
end