module Fastlane
  module Actions
    class GsGetBetaVersionAction < Action
      def self.run(params)
        require 'json'
        jsonstr = '{"РЕКОД-МТ Руководитель":{"beta":"1.11(2)","rc":"1.11(1)","release":"1.11(1)"},"Geo4ME iOS":{"beta":"2.13(2)","rc":"2.15(1)","release":"2.14(0)"},"ActiveMap Informer iOS":{"beta":"1.8(1)","rc":"1.9(1)","release":"1.8(1)"},"MyHome iOS":{"beta":"1.5(4)","rc":"1.6(0)","release":"1.5(1)"},"AutomapGS iOS":{"beta":"1.11(2)","rc":"1.11(1)","release":"1.11(1)"},"MapMobile iOS":{"beta":"3.20(4)","rc":"3.21(0)","release":"3.21(0)"},"REKOD-Registrator iOS":{"beta":"3.20(2)","rc":"3.21(0)","release":"3.21(0)"},"Release Notes Redactor iOS":{"beta":"1.6(10)","rc":"1.5(4)","release":"1.5(4)"}}' #FileHelper.read(params[:path]) #TODO: впилить проверку если не указан путь
        # UI.message(params[:path])
        UI.message(jsonstr)
        json = JSON.parse(jsonstr)
        v = Version.parse(json[params[:project_name]])
        v["beta"]
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
