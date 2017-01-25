module Fastlane
  module Actions
    class GsGetBetaVersionAction < Action
      def self.run(params)
        require 'json'
        jsonstr = FileHelper.read(params[:path]) #TODO: впилить проверку если не указан путь
        UI.message(jsonstr)
        json = JSON.parse(jsonstr)
        v = Version.parse(json[params[:project_name]])
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
                                         type: String),
            FastlaneCore::ConfigItem.new(key: :project_name,
                                         env_name: "PROJECT_NAME",
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
