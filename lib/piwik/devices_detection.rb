module Piwik
  class DevicesDetection < ApiModule
    available_methods %W{
      getType
      getBrand
      getModel
      getOsFamilies
      getOsVersions
      getBrowsers
      getBrowserVersions
      getBrowserEngines
    }
  end
end

