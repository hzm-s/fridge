# typed: false
require 'rails_helper'

module Pbi
  RSpec.describe StoryPoint do
    it do
      points = described_class.all
      expect(points.map(&:to_i)).to eq [0, 1, 2, 3, 5, 8, 13, nil]
    end

    it do
      point = described_class.new(nil)
      expect(point).to eq StoryPoint.unknown
    end

    it do
      point = described_class.new(0)
      expect(point.to_i).to eq 0
    end

    it do
      expect { described_class.new(21) }.to raise_error(ArgumentError)
    end
  end
end
