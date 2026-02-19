# frozen_string_literal: true

require_relative 'lib/administrate/version'

Gem::Specification.new do |spec|
  spec.name = 'administrate-sdk'
  spec.version = Administrate::VERSION
  spec.authors = ['Administrate']
  spec.email = ['support@administrate.dev']

  spec.summary = 'Ruby client for the Administrate.dev REST API'
  spec.description = 'Typed Ruby client for the Administrate.dev API with auto-pagination, retry, and typed exceptions.'
  spec.homepage = 'https://github.com/administrate-dev/administrate-ruby-sdk'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '>= 2.0', '< 3.0'
  spec.add_dependency 'faraday-retry', '>= 2.0', '< 3.0'
end
