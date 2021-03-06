require File.expand_path('../../lib/version', __FILE__)
lib_path = File.exists?('pakyow-rake') ? 'pakyow-rake' : '.'

Gem::Specification.new do |spec|
  spec.name                   = 'pakyow-rake'
  spec.summary                = 'Pakyow Rake'
  spec.description            = 'Rake tasks for Pakyow'
  spec.author                 = 'Bryan Powell'
  spec.email                  = 'bryan@metabahn.com'
  spec.homepage               = 'http://pakyow.org'
  spec.version                = Pakyow::VERSION
  spec.require_path           = File.join(lib_path, 'lib')
  spec.files                  = Dir[
                                  File.join(lib_path, 'CHANGELOG.md'),
                                  File.join(lib_path, 'README.md'),
                                  File.join(lib_path, 'LICENSE'),
                                  File.join(lib_path, 'lib/**/*')
                                ]
  spec.license                = 'MIT'
  spec.required_ruby_version  = '>= 2.0.0'

  spec.add_dependency('pakyow-support', Pakyow::VERSION)
  spec.add_dependency('pakyow-core', Pakyow::VERSION)
  spec.add_dependency('pakyow-presenter', Pakyow::VERSION)
  spec.add_dependency('rake', '~> 10.4')
end
