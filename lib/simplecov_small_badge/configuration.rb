# frozen_string_literal: true

module SimpleCovSmallBadge
  # Class to keep all the valid documentations that are required to build the
  # badge
  class Configuration
    # Set up config variables.
    # rubocop:disable Metrics/MethodLength
    def self.options
      {
        format: 'png',
        with_groups: false,
        background: 'transparent',
        title_prefix: 'scov',
        title_background: '#595959',
        title_font: 'Helvetica',
        title_font_size: 16,
        title_font_color: 'white',
        coverage_background_bad: 'red',
        coverage_background_unknown: 'yellow',
        coverage_background_good: '#4dc71f',
        coverage_font: 'Helvetica-Narrow-Bold',
        coverage_font_color: 'white',
        coverage_font_size: 16,
        badge_height: 30,
        filename_prefix: 'coverage_badge',
        log_level: 'info',
        rounded_border: true,
        rounded_edge_radius: 3
      }
    end
    # rubocop:enable Metrics/MethodLength

    # set up class variables and getters/setters
    options.keys.each do |opt|
      define_method(opt) { instance_variable_get "@#{opt}" }
      define_method("#{opt}=") { |val| instance_variable_set("@#{opt}", val) }
    end

    def initialize(**opts)
      SimpleCovSmallBadge::Configuration
        .options.merge(opts).each { |opt, v| send(:"#{opt}=", v) }
    end
  end
end
