module Fastlane
  module Actions
    class FileHelper
      def self.read(path)
        file = File.open(path, "r+")
        res = file.read
        file.close
        res
      end

      def self.write(path, str)
        file = File.open(path, "w+")
        file.write(str)
        file.close
      end
    end
    class GsIncrementBetaVersionAction < Action
      def self.run(params)
        require 'json'
        v_beta = Actions::GsGetBetaVersionAction.run(params)
        v_rc = Actions::GsGetRcVersionAction.run(params)
        if v_rc.major > v_beta.major || (v_rc.minor > v_beta.minor && v_rc.major == v_beta.major)
          v_beta.minor = v_rc.minor
          v_beta.major = v_rc.major
          v_beta.build = 0
        end
        v_beta.build += 1
        UI.message("New beta version " + v["beta"].to_s)
        v_beta
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
