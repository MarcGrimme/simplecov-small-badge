# frozen_string_literal: true

require 'spec_helper'

describe SimpleCovSmallBadge::Formatter do
  include TestSimpleCovSmallBadge::Mocks

  describe '#format' do
    context 'bad result' do
      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(90)
        mock_repo_badge_image(cov: '50%', state: 'bad')
        result = mock_result(50)
        expect(subject.format(result)).to be_truthy
      end
    end

    context 'good result' do
      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(100)
        image_mock = mock_repo_badge_image(title: 'total', name: 'total',
                                           cov: '100%')
        mock_repo_badge_image(title: 'library', name: 'library',
                              cov: '100%', mock: image_mock)
        result = mock_result(100, 'library' => mock_result_group(100))
        expect(subject.format(result)).to be_truthy
      end

      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(90)
        image_mock = mock_repo_badge_image(title: 'total', name: 'total',
                                           cov: '90%')
        mock_repo_badge_image(title: 'library', name: 'library',
                              cov: '90%', mock: image_mock)
        result = mock_result(90, 'library' => mock_result_group(90))
        expect(subject.format(result)).to be_truthy
      end
    end

    context 'bad result' do
      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(91)
        image_mock = mock_repo_badge_image(title: 'total', name: 'total',
                                           cov: '90%', state: 'bad')
        mock_repo_badge_image(title: 'library', name: 'library',
                              cov: '90%', state: 'bad', mock: image_mock)
        result = mock_result(90, 'library' => mock_result_group(90))
        expect(subject.format(result)).to be_truthy
      end
    end

    context 'unknown result' do
      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(nil)
        image_mock = mock_repo_badge_image(title: 'total', name: 'total',
                                           cov: '90%', state: 'unknown')
        mock_repo_badge_image(title: 'library', name: 'library',
                              cov: '90%', state: 'unknown', mock: image_mock)
        result = mock_result(90, 'library' => mock_result_group(90))
        expect(subject.format(result)).to be_truthy
      end
    end

    context 'mixed result' do
      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(90)
        image_mock = mock_repo_badge_image(title: 'total', name: 'total',
                                           cov: '89%', state: 'bad')
        mock_repo_badge_image(title: 'library', name: 'library',
                              cov: '90%', state: 'good', mock: image_mock)
        result = mock_result(89, 'library' => mock_result_group(90))
        expect(subject.format(result)).to be_truthy
      end
    end
  end
end
