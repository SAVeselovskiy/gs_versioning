module Fastlane
  module Actions
    class GsIncrementRcVersionAction < Action
      def self.run(params)
        require 'json'
        v_rc = Actions::GsGetRcVersionAction.run(params)
        v_release = Actions::GsGetReleaseVersionAction.run(params)
        build = GetVersionNumberFromPlistAction.run(xcodeproj: ENV["xcodeproj"], target: ENV["target"])
        major = build.split('.')[0].to_i
        if major > v_rc.major
          v_rc.major = major
          v_rc.minor = 0
          v_rc.build = 1
        elsif major < v_rc.major
          raise "Wrong major number specified in Info.plist. Version major number can't be less than current major number on app store (and versions.json file)"
        elsif v_release.major < v_rc.major || v_release.minor < v_rc.minor
          v_rc.build += 1
        else
          v_rc.minor += 1
          v_rc.build = 1
        end
        res = v_rc.toString
        UI.message("New relese_candidate version " + res)
        v_rc
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
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :project_name,
                                       env_name: "ALIAS",
                                       description: "project name for versions file access",
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
