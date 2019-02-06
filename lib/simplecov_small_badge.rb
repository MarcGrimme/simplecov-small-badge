# frozen_string_literal: true

# Ensure we are using a compatible version of SimpleCov
# :nocov:
if defined?(SimpleCov::VERSION) &&
   Gem::Version.new(SimpleCov::VERSION) < Gem::Version.new('0.7.1')
  raise 'The version of SimpleCov you are using is too old. '\
    'Please update with `gem install simplecov` or `bundle update simplecov`'
end
# :nocov:

require 'simplecov_small_badge/configuration'
# :nodoc:
module SimpleCovSmallBadge
  @configuration = Configuration.new
  def self.configure
    yield config
  end

  def self.config
    @configuration
  end
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
require 'simplecov_small_badge/version'
require 'simplecov_small_badge/formatter'
