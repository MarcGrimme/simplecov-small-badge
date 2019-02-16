# frozen_string_literal: true

require 'repo_small_badge/image'
require 'simplecov_small_badge/configuration'

module SimpleCovSmallBadge
  # Basic Badge Formater Class that creates the badges.
  class Formatter
    def initialize(output = nil)
      @output = output || STDOUT
      @config = SimpleCovSmallBadge.config
    end

    def format(result)
      percent = result.source_files.covered_percent.round(0)
      @image = RepoSmallBadge::Image.new(map_image_config(state(percent)))
      badge('total', 'total', percent)
      group_percent_from_result(result) do |name, title, cov_percent|
        badge(name, title, cov_percent.round(0))
      end
    end

    private

    def badge(name, title, percent)
      percent_txt = percent_text(percent)
      @image.config_merge(map_image_config(state(percent)))
      @image.badge(name, title, percent_txt)
    end

    def percent_text(percent)
      "#{percent}#{@config.percent_sign}"
    end

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

    def map_image_config(state)
      hash = {}
      @config.to_hash.map do |key, value|
        key = key
              .to_s.sub(/^coverage_background_#{state}/, 'value_background')
              .to_sym
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
