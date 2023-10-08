# frozen_string_literal: true

require 'spec_helper'

describe SimpleCovSmallBadge::Formatter do
  include TestSimpleCovSmallBadge::Mocks

  describe '#format' do
    context 'bad result' do
      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(line: 90)
        mock_repo_badge_image(cov: '50%', state: 'bad')
        result = mock_result(50)
        expect(subject.format(result)).to be_truthy
      end
    end

    context 'good result' do
      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(line: 100)
        image_mock = mock_repo_badge_image(title: 'total', name: 'total',
                                           cov: '100%')
        mock_repo_badge_image(title: 'library', name: 'library',
                              cov: '100%', mock: image_mock)
        result = mock_result(100, 'library' => mock_result_group(100))
        expect(subject.format(result)).to be_truthy
      end

      it do
        allow(SimpleCov).to receive(:minimum_coverage).and_return(line: 90)
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
        allow(SimpleCov).to receive(:minimum_coverage).and_return(line: 91)
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
        allow(SimpleCov).to receive(:minimum_coverage).and_return({})
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
        allow(SimpleCov).to receive(:minimum_coverage).and_return(line: 90)
        image_mock = mock_repo_badge_image(title: 'total', name: 'total',
                                           cov: '89%', state: 'bad')
        mock_repo_badge_image(title: 'library', name: 'library',
                              cov: '90%', state: 'good', mock: image_mock)
        result = mock_result(89, 'library' => mock_result_group(90))
        expect(subject.format(result)).to be_truthy
      end
    end

    context 'with branch coverage' do
      before do
        SimpleCov.enable_coverage :branch
        SimpleCov.primary_coverage :branch
        allow(SimpleCov).to receive(:minimum_coverage)
          .and_return(minimum_coverage)
      end

      after do
        SimpleCov.clear_coverage_criteria
        SimpleCov.enable_coverage :line
        SimpleCov.primary_coverage :line
      end

      context 'when coverage is lower than required' do
        let(:minimum_coverage) { { branch: 90, line: 100 } }
        let(:coverage) { 50 }
        let(:expected_state) { 'bad' }

        it 'is bad' do
          mock_repo_badge_image(cov: "#{coverage}%", state: expected_state)
          result = mock_result(coverage)
          subject.format(result)
        end
      end

      context 'when coverage is lower than required with groups' do
        let(:minimum_coverage) { { branch: 91, line: 100 } }
        let(:coverage) { 90 }
        let(:expected_state) { 'bad' }

        it 'is bad' do
          image_mock = mock_repo_badge_image(title: 'total', name: 'total',
                                             cov: "#{coverage}%",
                                             state: expected_state)
          mock_repo_badge_image(title: 'library', name: 'library',
                                cov: "#{coverage}%", state: expected_state,
                                mock: image_mock)
          result = mock_result(coverage,
                               'library' => mock_result_group(coverage))
          subject.format(result)
        end
      end

      context 'when coverage is greater than or equal to that required' do
        let(:minimum_coverage) { { branch: 100, line: 10 } }
        let(:coverage) { 100 }
        let(:expected_state) { 'good' }

        it 'is good' do
          mock_repo_badge_image(cov: '100%', state: expected_state)
          result = mock_result(coverage)
          subject.format(result)
        end
      end

      context 'when coverage is greater than or equal to that required with groups' do
        let(:minimum_coverage) { { branch: 100, line: 10 } }
        let(:coverage) { 100 }
        let(:expected_state) { 'good' }

        it 'is good' do
          image_mock = mock_repo_badge_image(title: 'total', name: 'total',
                                             cov: "#{coverage}%")
          mock_repo_badge_image(title: 'library', name: 'library',
                                cov: "#{coverage}%", mock: image_mock)
          result = mock_result(coverage, 'library' => mock_result_group(coverage))
          subject.format(result)
        end
      end

      context 'when minimum coverage is not set' do
        let(:minimum_coverage) { {} }
        let(:coverage) { 90 }
        let(:expected_state) { 'unknown' }

        it 'is unknown' do
          mock_repo_badge_image(cov: "#{coverage}%",
                                state: expected_state)
          result = mock_result(coverage)
          expect(subject.format(result)).to be_truthy
        end
      end

      context 'when minimum coverage is not set with groups' do
        let(:minimum_coverage) { {} }
        let(:coverage) { 90 }
        let(:expected_state) { 'unknown' }

        it 'is unknown' do
          image_mock = mock_repo_badge_image(title: 'total', name: 'total',
                                             cov: "#{coverage}%",
                                             state: expected_state)
          mock_repo_badge_image(title: 'library', name: 'library',
                                cov: "#{coverage}%", state: expected_state,
                                mock: image_mock)
          result = mock_result(coverage,
                               'library' => mock_result_group(coverage))
          expect(subject.format(result)).to be_truthy
        end
      end

      context 'when global coverage is lower but group coverage is as required' do
        let(:minimum_coverage) { { branch: 90, line: 10 } }
        let(:global_coverage) { 89 }
        let(:group_coverage) { 90 }
        let(:global_state) { 'bad' }
        let(:group_state) { 'good' }

        it 'is mixed' do
          image_mock = mock_repo_badge_image(title: 'total', name: 'total',
                                             cov: "#{global_coverage}%",
                                             state: global_state)
          mock_repo_badge_image(title: 'library', name: 'library',
                                cov: "#{group_coverage}%",
                                state: group_state,
                                mock: image_mock)
          result = mock_result(global_coverage,
                               'library' => mock_result_group(group_coverage))
          subject.format(result)
        end
      end
    end
  end
end
