# frozen_string_literal: true

require 'repo_small_badge/image'
require 'simplecov_small_badge/configuration'

module SimpleCovSmallBadge
  # Basic Badge Formater Class that creates the badges.
  class Formatter
    def initialize(output = nil)
      @output = output || STDOUT
      @config = SimpleCovSmallBadge.config
      @image = RepoSmallBadge::Image.new(map_image_config)
    end

    def format(result)
      covered_percent = result.source_files.covered_percent.round(0)
      @image.badge('total', 'total', covered_percent,
                   state(covered_percent))
      group_percent_from_result(result) do |name, title, percent|
        @image.badge(name, title, percent, state(percent))
      end
    end

    private

    def state(covered_percent)
      if SimpleCov.minimum_coverage&.positive?
        if covered_percent >= SimpleCov.minimum_coverage
          'good'
        else
          'bad'
        end
      else
        'unknown'
      end
    end

    def map_image_config
      hash = {}
      @config.to_hash.map do |key, value|
        key = key.to_s.sub(/^coverage_/, 'value_').to_sym
        hash[key] = value
      end
      hash
    end

    # converts the result to a hash consisting of the groupname
    # array of percentage (integer in percent), strength float
    # and the state [ 'good', 'bad', 'unknown' ]
    # consolidated for each group.
    def group_percent_from_result(result)
      result.groups.each do |name, files|
        covered = files.covered_percent.round(0)
        yield name, name, covered, covered
      end
    end
  end
end
