require 'rails_helper'

RSpec.describe Pbi::Content do
  it do
    expect { described_class.from_string('a' * 10) }.to_not raise_error
  end

  it '2文字以下はエラー' do
    expect { described_class.from_string('a' * 2) }.to raise_error(ArgumentError)
  end

  it '501文字以上はエラー' do
    expect { described_class.from_string('a' * 501) }.to raise_error(ArgumentError)
  end
end
