# frozen_string_literal: true

module TestSimpleCovSmallBadge
  module Mocks
    # rubocop:disable Metrics/ParameterLists, Metrics/AbcSize
    def mock_repo_badge_image(cov: 100, name: 'total',
                              title: 'total',
                              state: 'good',
                              config: {},
                              mock: instance_double('Image'))
      config = map_config_options(config, state)
      allow(RepoSmallBadge::Image).to receive(:new)
        .with(config).and_return(mock)
      allow(mock).to receive(:config_merge).with(config).and_return(config)
      allow(mock).to receive(:badge).with(name, title, cov)
      mock
    end
    # rubocop:enable Metrics/ParameterLists, Metrics/AbcSize

    def map_config_options(config_hash, state)
      hash = {}
      SimpleCovSmallBadge::Configuration.options.merge(config_hash)
                                        .map do |key, value|
        key = key.to_s
                 .sub(/^coverage_background_#{state}/, 'value_background')
                 .to_sym
        key = key.to_s.sub(/^coverage_/, 'value_').to_sym
        hash[key] = value
      end
      hash
    end

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
