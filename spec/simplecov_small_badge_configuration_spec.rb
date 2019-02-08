# frozen_string_literal: true

require 'spec_helper'

describe SimpleCovSmallBadge::Configuration do
  described_class.options.each do |opt, value|
    context "\##{opt}" do
      it { expect(subject.send(opt)).to eq(value) }
    end
  end
end
