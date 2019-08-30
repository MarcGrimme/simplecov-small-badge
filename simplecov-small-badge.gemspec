# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'simplecov_small_badge/version'

Gem::Specification.new do |s|
  s.name        = 'simplecov-small-badge'
  s.version     = SimpleCovSmallBadge::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Marc Grimme']
  s.email       = ['marc.grimme at gmail dot com']
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/marcgrimme/simplecov-small-badge'
  s.summary     = %(Small Badge generator for SimpleCov coverage tool for ruby)

  s.rubyforge_project = 'simplecov-small-badge'

  s.add_dependency 'repo-small-badge', '~> 0.2.7'
  s.add_dependency 'simplecov', '~> 0.17'
  s.add_development_dependency 'rake', '~> 12'
  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 0.65'
  s.add_development_dependency 'rubycritic', '~> 4.1'
  s.add_development_dependency 'rubycritic-small-badge', '~> 0.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`
                    .split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
