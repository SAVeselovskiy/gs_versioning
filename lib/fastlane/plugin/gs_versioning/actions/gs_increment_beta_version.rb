module Fastlane
  module Actions
    class Version
      attr_accessor :minor, :patch, :major, :build

      def initialize(major, minor, patch, build)
        # assign instance avriables
        @major, @minor, @patch, @build = major,minor,patch,build
      end
      def self.parse(parsed)
        #TODO: впилить проверку на правильный формат
        {"beta" => self.parse_beta(parsed), "rc" => self.parse_rc(parsed),"release" => self.parse_release(parsed)}
      end
      def self.parse_beta(parsed)
        beta_version = parsed["beta"]["version"]
        self.parse_string(beta_version)
      end
      def self.parse_rc(parsed)
        rc_version = parsed["rc"]["version"]
        self.parse_string(rc_version)
      end
      def self.parse_release(parsed)
        release_version = parsed["release"]["version"]
        self.parse_string(release_version)
      end
      def self.parse_string(str)
        v_elements = str.split(pattern='.')
        patch_build_values = [v_elements[2].split(pattern='(')[0],  v_elements[2].split(pattern='(')[1].split(pattern=')')[0]]
        Version.new(v_elements[0].to_i,v_elements[1].to_i,patch_build_values[0].to_i,patch_build_values[1].to_i)
      end

      def toString
        res = @major.to_s + '.' + @minor.to_s + '.' + @patch.to_s + '(' + @build.to_s + ')'
      end
    end
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
        require 'rubygems'
        require 'json'
        require 'fastlane/plugin/versioning'
        jsonstr = FileHelper.read(params[:path]) #TODO: впилить проверку если не указан путь
        json = JSON.parse(jsonstr)
        UI.message(json)
        v = Version.parse(json)
        v["beta"].build += 1
        UI.message(OtherAction.get_build_number_from_plist)
        res = v["beta"].toString
        UI.message("New beta version " + res)
        json["beta"]["version"] = res
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
