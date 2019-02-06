# frozen_string_literal: true

require 'simplecov_small_badge/image'
require 'simplecov_small_badge/configuration'

module SimpleCovSmallBadge
  # Basic Badge Formater Class that creates the badges.
  class Formatter
    def initialize(output = nil)
      @output = output || STDOUT
      @config = SimpleCovSmallBadge.config
      @image = SimpleCovSmallBadge::Image.new(@config)
    end

    def format(result)
      covered_percent = result.source_files.covered_percent.round(0)
      @image.coverage(covered_percent,
                      state(covered_percent),
                      group_percent_from_result(result))
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

    # converts the result to a hash consisting of the groupname
    # array of percentage (integer in percent), strength float
    # and the state [ 'good', 'bad', 'unknown' ]
    # consolidated for each group.
    def group_percent_from_result(result)
      groups = {}
      result.groups.each do |name, files|
        covered = files.covered_percent.round(0)
        groups[name] = [covered,
                        files.covered_strength,
                        state(covered)]
      end
      groups
    end
  end
end
