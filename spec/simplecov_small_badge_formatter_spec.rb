# frozen_string_literal: true

require 'spec_helper'

describe SimpleCovSmallBadge::Formatter do
  include TestSimpleCovSmallBadge::Mocks

  let(:stack) { mock_mini_magick_stack }
  describe '#format' do
    context 'bad result' do
      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(90)
        mock_mini_magick(name: 'total', title: 'scov total',
                         color: 'red', coverage: '50',
                         stack: stack)
        result = mock_result(50)
        expect(subject.format(result)).to be_truthy
      end
    end
    context 'good result' do
      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(100)
        mock_mini_magick(name: 'library', title: 'scov library',
                         color: '#4dc71f', coverage: '100',
                         stack: stack, convert:
                         mock_mini_magick(name: 'total', title: 'scov total',
                                          color: '#4dc71f', coverage: '100',
                                          stack: stack))
        result = mock_result(100, 'library': mock_result_group(100))
        expect(subject.format(result)).to be_truthy
      end

      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(90)
        mock_mini_magick(name: 'library', title: 'scov library',
                         color: '#4dc71f', coverage: '90',
                         stack: stack, convert:
                         mock_mini_magick(name: 'total', title: 'scov total',
                                          color: '#4dc71f', coverage: '90',
                                          stack: stack))
        result = mock_result(90, 'library': mock_result_group(90))
        expect(subject.format(result)).to be_truthy
      end
    end

    context 'bad result' do
      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(91)
        mock_mini_magick(name: 'library', title: 'scov library',
                         color: 'red', coverage: '90',
                         stack: stack, convert:
                         mock_mini_magick(name: 'total', title: 'scov total',
                                          color: 'red', coverage: '90',
                                          stack: stack))
        result = mock_result(90, 'library': mock_result_group(90))
        expect(subject.format(result)).to be_truthy
      end
    end

    context 'unknown result' do
      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(nil)
        mock_mini_magick(name: 'library', title: 'scov library',
                         color: 'yellow', coverage: '90',
                         stack: stack, convert:
                         mock_mini_magick(name: 'total', title: 'scov total',
                                          color: 'yellow', coverage: '90',
                                          stack: stack))
        result = mock_result(90, 'library': mock_result_group(90))
        expect(subject.format(result)).to be_truthy
      end
    end

    context 'mixed result' do
      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(90)
        mock_mini_magick(name: 'library', title: 'scov library',
                         color: '#4dc71f', coverage: '90',
                         stack: stack, convert:
                         mock_mini_magick(name: 'total', title: 'scov total',
                                          color: 'red', coverage: '89',
                                          stack: stack))
        result = mock_result(89, 'library': mock_result_group(90))
        expect(subject.format(result)).to be_truthy
      end
    end
  end
end
