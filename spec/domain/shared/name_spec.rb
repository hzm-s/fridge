# typed: false
require 'domain_helper'

module Shared
  RSpec.describe Name do
    it do
      s = described_class.new('fridge')
      expect(s.to_s).to eq 'fridge'
    end

    it do
      a = described_class.new('aaa')
      b = described_class.new('bbb')
      expect(a).to eq described_class.new(a.to_s)
      expect(a).to_not eq b
    end

    it do
      aggregate_failures do
        expect { described_class.new('') }.to raise_error InvalidName
        expect { described_class.new('a' * 1) }.to_not raise_error
        expect { described_class.new('a' * 50) }.to_not raise_error
        expect { described_class.new('a' * 51) }.to raise_error InvalidName
      end
    end
  end
end
