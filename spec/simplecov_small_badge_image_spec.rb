# frozen_string_literal: true

require 'spec_helper'

describe SimpleCovSmallBadge::Image do
  include TestSimpleCovSmallBadge::Mocks

  context '#coverage_total' do
    let(:config) { SimpleCovSmallBadge.config }
    subject { described_class.new(config) }

    describe '#coverage' do
      context 'with group' do
        it do
          stack = mock_mini_magick_stack
          mock_mini_magick(name: 'library', title: 'scov library',
                           color: '#4dc71f', coverage: '100',
                           stack: stack,
                           convert:
                           mock_mini_magick(name: 'total', title: 'scov total',
                                            color: '#4dc71f', coverage: '100',
                                            stack: stack))
          expect(subject.coverage(100, 'good', 'library': [100, 1, 'good']))
            .to be_truthy
        end
      end

      context 'no group' do
        it do
          stack = mock_mini_magick_stack
          mock_mini_magick(name: 'total', title: 'scov total',
                           color: '#4dc71f', coverage: '100',
                           stack: stack)
          expect(subject.coverage(100, 'good')).to be_truthy
        end
      end

      context 'without rounded' do
        it do
          allow(SimpleCovSmallBadge).to receive(:config)
            .and_return(SimpleCovSmallBadge::Configuration
              .new(rounded_border: false))
          stack = mock_mini_magick_stack
          mock_mini_magick(name: 'total', title: 'scov total',
                           color: '#4dc71f', coverage: '100',
                           rounded_border: false,
                           stack: stack)
          expect(subject.coverage(100, 'good')).to be_truthy
        end
      end
    end
  end
end
