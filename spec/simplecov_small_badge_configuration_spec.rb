# frozen_string_literal: true

require 'spec_helper'

describe SimpleCovSmallBadge::Configuration do
  described_class.options.each do |opt, value|
    context "\##{opt}" do
      it { expect(subject.send(opt)).to eq(value) }
    end
  end

  context '#to_hash' do
    it { expect(subject.to_hash).to eq(described_class.options) }
  end
end
