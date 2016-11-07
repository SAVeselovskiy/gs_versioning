module Fastlane
  module Actions
    class Version
      attr_accessor :minor, :patch, :major, :build

      def initialize(major, minor, patch, build)
      # assign instance avriables
        @major, @minor, @patch, @build = major,minor,patch,build
      end
      def self.parse(parsed)
        beta_version = parsed["beta"]["version"]
        v_elements = beta_version.split(pattern='.')
        patch_build_values = [v_elements[2].split(pattern='(')[0],  v_elements[2].split(pattern='(')[1].split(pattern=')')[0]]
        Version.new(v_elements[0].to_i,v_elements[1].to_i,patch_build_values[0].to_i,patch_build_values[1].to_i)
      end
      def toString
        res = @major.to_s + '.' + @minor.to_s + '.' + @patch.to_s + '(' + @build.to_s + ')'
      end
   end
    class GsIncrementBetaVersionAction < Action
      def self.run(params)
        file = File.open(params[:path], "r+")
        json = file.read
        file.close
        UI.message(json)
        parsed = JSON.parse(json)
        v = Version.parse(parsed)
        v.build += 1

        res = v.toString
        UI.message("New beta version " + res)
        parsed["beta"]["version"] = res
        file = File.open(params[:path], "w+")
        file.write(parsed.to_json)
        file.close
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
