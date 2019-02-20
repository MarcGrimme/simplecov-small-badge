# frozen_string_literal: true

module SimpleCovSmallBadge
  # Class to keep all the valid documentations that are required to build the
  # badge
  class Configuration
    # Set up config variables.
    # rubocop:disable Metrics/MethodLength
    def self.options
      {
        with_groups: false,
        background: '#fff',
        title_prefix: 'scov',
        title_background: '#555',
        title_font: 'Verdana,sans-serif',
        font_size: 11,
        title_color: '#fff',
        coverage_background_bad: '#ff0000',
        coverage_background_unknown: '#cccc00',
        coverage_background_good: '#4dc71f',
        coverage_font: 'Verdana,sans-serif',
        coverage_font_color: '#fff',
        coverage_font_size: 11,
        badge_height: 20,
        badge_width: 120,
        filename_prefix: 'coverage_badge',
        output_path: SimpleCov.coverage_path,
        log_level: 'info',
        rounded_border: true,
        rounded_edge_radius: 3,
        percent_sign: '%'
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

    def to_hash
      hash = {}
      instance_variables.each do |var|
        hash[var.to_s.delete('@').to_sym] = instance_variable_get(var)
      end
      hash
    end
  end
end
