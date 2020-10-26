# frozen_string_literal: true

require 'simplecov'
require 'byebug'

module SimpleCovSmallBadge
  class Formatter
  end
end

SimpleCov.start do
  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCovSmallBadge::Formatter
    ]
  )
end

SimpleCov.minimum_coverage 100

require 'simplecov_small_badge'
require 'rubygems'
require 'bundler/setup'

Dir[File.join('./spec/support/*.rb')].sort.each { |f| require f }

SimpleCovSmallBadge.configure do |config|
  # config.rounded_border = false
end

RSpec.configure do |config|
  # some (optional) config here
end
