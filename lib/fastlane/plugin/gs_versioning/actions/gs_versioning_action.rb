module Fastlane
  module Actions
    class Version
      def initialize(major,minor,patch,build)
      # assign instance avriables
        @major, @minor, @patch, @build = major,minor,patch,build
      end
      def self.parse(jsonstr)
        parsed = JSON.parse(jsonstr)
        beta_version = parsed["beta"]["version"]
        v_elements = beta_version.split(pattern=',')
        patch_build_values = [v_elements.split(pattern='(')[0],  v_elements.split(pattern='(')[1].split(pattern=')')[0]]
        Version(v_elements[0].to_i,v_elements[1].to_i,patch_build_values[0].to_i,patch_build_values[1].to_i)
      end
      def toString
        res = @major.to_s + '.' + @minor + '.' + @patch.to_s + '(' + @build + ')'
      end
   end
    class GsVersioningAction < Action
      def self.run(params)
        file = File.open(paramth["path"], "w+")
        json = file.read
        UI.message(json)
        
        v = Version.parse(json)
        v.build = 15

        res = v.toString
        file.write(res)
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
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "GS_VERSIONING_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
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
