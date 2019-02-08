# frozen_string_literal: true

require 'mini_magick'

ImageMagickError = Class.new(StandardError)

# :nodoc:
module SimpleCovSmallBadge
  # Class that handles the creation of the different images
  class Image
    def initialize(config)
      raise ImageMagicError, 'Imagemagick is not installed on this system.' \
        unless MiniMagick.imagemagick?

      @config = config
      MiniMagick.logger = Logger.new($stdout, level: @config.log_level.to_sym)
    end

    # Creates the image for total coverage
    # @coverage is the overall coverage in percent as integer
    # @state can be either good, bad, unknown
    # @groups the groups to be drawn too (default: {}). It's a hash of
    #     groupname and coverage as integer percent over the group
    def coverage(coverage, state, groups = {})
      coverage_group('total', coverage, state)
      groups.each do |group_name, group|
        coverage_group(group_name, group[0], group[2])
      end
      true
    end

    private

    def coverage_group(group_name, coverage, state)
      MiniMagick::Tool::Convert.new do |convert|
        convert.gravity('center')
        convert.background(@config.background)
        convert.pango(pango(group_name => [coverage, 1, state]))
        rounded_border? && rounded_border(convert, @config.rounded_edge_radius)
        convert << filename(group_name)
      end
    end

    # rubocop:disable Lint/Void, Metrics/LineLength, Metrics/MethodLength, Metrics/AbcSize
    def rounded_border(convert, radius = 15)
      convert.stack do |stack|
        stack.clone.+
        stack.alpha('extract')
        stack.draw("fill black polygon 0,0 0,#{radius} #{radius},0 fill white circle #{radius},#{radius} #{radius},0")
        stack.stack do |stack1|
          stack1.clone.+
          stack1.flip
        end
        stack.compose('Multiply')
        stack.composite
        stack.stack do |stack1|
          stack1.clone.+
          stack1.flop
        end
        stack.compose('Multiply')
        stack.composite
      end
      convert.alpha('off')
      convert.compose('CopyOpacity')
      convert.composite
    end
    # rubocop:enable Lint/Void, Metrics/LineLength, Metrics/MethodLength, Metrics/AbcSize

    def rounded_border?
      @config.rounded_border
    end

    def pango(groups)
      groups.map do |name, stats|
        "#{pango_title(name)}#{pango_coverage(stats[0], stats[2])}"
      end.join(' ')
    end

    def pango_title(suffix)
      pango_text title(suffix), @config.title_font,
                 @config.title_font_color, @config.title_font_size,
                 @config.title_background
    end

    def pango_coverage(coverage, state)
      pango_text " #{coverage} &#37; ", @config.coverage_font,
                 @config.coverage_font_color, @config.coverage_font_size,
                 coverage_background(state)
    end

    def pango_text(text, font, font_color, font_size, background)
      "<span foreground=\"#{font_color}\"
             background=\"#{background}\"\
             size=\"#{font_size * 1000}\"\
             font=\"#{font}\"\
        >#{text}</span>"
    end

    def coverage_background(state)
      @config.send(:"coverage_background_#{state}")
    end

    def filename(suffix = '')
      "#{output_path}/#{@config.filename_prefix}_#{suffix}.#{@config.format}"
    end

    def title(suffix)
      " #{@config.title_prefix} #{suffix} "
    end

    def output_path
      SimpleCov.coverage_path
    end
  end
end
