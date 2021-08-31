# typed: false
require 'domain_helper'

module Shared
  RSpec.describe ShortSentence do
    it do
      s = described_class.new('short sentence')
      expect(s.to_s).to eq 'short sentence'
    end

    it do
      a = described_class.new('aaa')
      b = described_class.new('bbb')
      expect(a).to eq a
      expect(a).to_not eq b
    end

    it do
      aggregate_failures do
        expect { described_class.new('a' * 1) }.to raise_error SentenceIsTooShort
        expect { described_class.new('a' * 2) }.to_not raise_error
        expect { described_class.new('a' * 100) }.to_not raise_error
        expect { described_class.new('a' * 101) }.to raise_error SentenceIsTooLong
      end
    end
  end
end
