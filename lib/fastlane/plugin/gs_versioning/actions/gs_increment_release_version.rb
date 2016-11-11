module Fastlane
  module Actions
    class GsIncrementReleaseVersionAction < Action
      def self.run(params)
        require 'json'
        require 'fastlane/plugin/versioning/actions/get_version_number_from_plist'
        jsonstr = FileHelper.read(params[:path]) #TODO: впилить проверку если не указан путь
        UI.message(jsonstr)
        json = JSON.parse(jsonstr)
        v = Version.parse(json)

        build = GetVersionNumberFromPlistAction.run(xcodeproj:ENV["xcodeproj"], target:ENV["target"])
        major = build.split('.')[0].to_i

        UI.message(v["rc"].toString)
        UI.message(v["release"].toString)
        if major < v["release"].major
          raise "Wrong major number specified in Info.plist. Version major number can't be less than current major number on app store (and versions.json file)"
        elsif v["rc"] <= v["release"]
          raise "Release candidate version lower than release version. You have to send release candidate version
on TestFlight and test it first. After that you can send version to review."
        else
          v["release"] = v["rc"]
        end


        res = v["release"].toString
        UI.message("New relese version " + res)
        v["release"]
      end

      def self.description
        "Plugin for GradoService versioning system"
      end

      def self.authors
        ["SAVeselovskiy"]
      end
      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Plugin for GradoService versioning system"
      end

      def self.available_options
        [
            FastlaneCore::ConfigItem.new(key: :path,
                                         env_name: "GS_VERSIONS_FILE_PATH",
                                         description: "path to versions file",
                                         optional: false,
                                         type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Platforms.md
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
