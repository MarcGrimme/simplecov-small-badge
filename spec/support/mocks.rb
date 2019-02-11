# frozen_string_literal: true

module TestSimpleCovSmallBadge
  module Mocks
    # rubocop:disable Metrics/LineLength
    def pango_text_match(title = 'scov total', color = 'green', cov = '100%')
      %(<span foreground="white"
             background="#595959"             size="16000"             font="Helvetica"        > #{title} </span><span foreground="white"
             background="#{color}"             size="16000"             font="Helvetica-Narrow-Bold"        > #{cov} </span>)
    end
    # rubocop:enable Metrics/LineLength

    # rubocop:disable Metrics/LineLength, Metrics/AbcSize
    def mock_mini_magick_stack(stack = instance_double('Stack'))
      allow(stack).to receive_message_chain('clone.+')
      allow(stack).to receive(:alpha).with('extract')
      allow(stack).to receive(:draw).with('fill black polygon 0,0 0,3 3,0 fill white circle 3,3 3,0')
      allow(stack).to receive(:flip)
      allow(stack).to receive(:flop)
      allow(stack).to receive(:compose).with('Multiply')
      allow(stack).to receive(:composite)
      allow(stack).to receive(:stack).and_yield(stack)
      stack
    end
    # rubocop:enable Metrics/LineLength, Metrics/AbcSize

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def mock_mini_magick(**keys)
      keys[:convert] ||= instance_double('Convert')
      convert = keys[:convert]
      pango_text = pango_text_match(keys[:title], keys[:color], keys[:coverage])
      allow(MiniMagick::Tool::Convert)
        .to receive(:new).and_yield(keys[:convert])
      allow(convert).to receive(:gravity).with('center')
      allow(convert).to receive(:background).with('transparent')
      allow(convert).to receive(:pango).with(pango_text)

      if keys.fetch(:rounded_border, true)
        allow(convert).to receive(:stack).and_yield(keys[:stack])
        allow(convert).to receive(:compose).with('CopyOpacity')
        allow(convert).to receive(:alpha).with('off')
        allow(convert).to receive(:composite)
      end
      allow(convert).to receive(:<<)
        .with("#{SimpleCov.coverage_path}/coverage_badge_#{keys[:name]}.png")
      convert
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    def mock_result(total_cov, groups_hash = {})
      result_double = instance_double('Result')
      allow(result_double)
        .to receive_message_chain('source_files.covered_percent')
        .and_return(total_cov)
      allow(result_double).to receive('groups').and_return(groups_hash)
      result_double
    end

    def mock_result_group(cov, strength = 1)
      group_double = instance_double('Group')
      allow(group_double)
        .to receive('covered_percent')
        .and_return(cov)
      allow(group_double)
        .to receive('covered_strength')
        .and_return(strength)
      group_double
    end
  end
end
