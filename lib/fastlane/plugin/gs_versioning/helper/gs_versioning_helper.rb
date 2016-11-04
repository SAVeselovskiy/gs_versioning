module Fastlane
  module Helper
    class GsVersioningHelper
      # class methods that you define here become available in your action
      # as `Helper::GsVersioningHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the gs_versioning plugin helper!")
      end
    end
  end
end
