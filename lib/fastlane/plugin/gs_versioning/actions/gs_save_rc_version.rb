module Fastlane
  module Actions
    class GsSaveRcVersionAction < Action
      def self.run(params)
        require 'json'
        jsonstr = FileHelper.read(params[:path]) #TODO: впилить проверку если не указан путь
        UI.message(jsonstr)
        json = JSON.parse(jsonstr)
        res = params[:version].toString
        UI.message("New relese_candidate version " + res)
        json[params[:project_name]]["rc"] = res
        FileHelper.write(params[:path],json.to_json)
        UI.message("The gs_versioning plugin is working!")
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
            FastlaneCore::ConfigItem.new(key: :version,
                                         env_name: "GS_APP_VERSION",
                                         description: "App version",
                                         optional: false,
                                         type: Version),
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
