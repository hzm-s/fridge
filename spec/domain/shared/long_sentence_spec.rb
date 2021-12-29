# typed: false
require 'domain_helper'

module Shared
  describe LongSentence do
    it do
      s = described_class.new('long sentence')
      expect(s.to_s).to eq 'long sentence'
    end

    it do
      a = described_class.new('aaa')
      b = described_class.new('bbb')
      expect(a).to eq described_class.new(a.to_s)
      expect(a).to_not eq b
    end

    it do
      aggregate_failures do
        expect { described_class.new('a' * 1) }.to raise_error InvalidLongSentence
        expect { described_class.new('a' * 3) }.to_not raise_error
        expect { described_class.new('a' * 500) }.to_not raise_error
        expect { described_class.new('a' * 501) }.to raise_error InvalidLongSentence
      end
    end
  end
end
