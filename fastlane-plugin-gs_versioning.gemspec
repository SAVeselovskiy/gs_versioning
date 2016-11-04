# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/gs_versioning/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-gs_versioning'
  spec.version       = Fastlane::GsVersioning::VERSION
  spec.author        = %q{SAVeselovskiy}
  spec.email         = %q{veselovskiysergey94@gmail.com}

  spec.summary       = %q{Plugin for GradoService versioning system}
  # spec.homepage      = "https://github.com/<GITHUB_USERNAME>/fastlane-plugin-gs_versioning"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 1.107.0'
end
