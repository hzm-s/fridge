# typed: false
require 'domain_helper'

module Issue
  RSpec.describe Description do
    it do
      aggregate_failures do
        expect { described_class.new('a' * 3) }.to_not raise_error
        expect { described_class.new('a' * 500) }.to_not raise_error
      end
    end

    it '2文字以下はエラー' do
      expect { described_class.new('a' * 2) }.to raise_error(ArgumentError)
    end

    it '501文字以上はエラー' do
      expect { described_class.new('a' * 501) }.to raise_error(ArgumentError)
    end
  end
end
