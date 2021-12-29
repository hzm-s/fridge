# typed: false
require 'rails_helper'

describe UpdatePbiForm do
  let(:valid) do
    {
      description: 'ABC',
    }
  end

  it do
    form = described_class.new(valid.merge(type: 'feature'))
    expect(form.type).to eq 'feature'
  end

  it do
    form = described_class.new(valid)
    expect(form).to be_valid
  end

  it do
    form = described_class.new(valid.merge(description: ''))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:description]).to include(I18n.t('errors.messages.blank'))
    end
  end

  it do
    form = described_class.new(valid.merge(description: 'a' * 1000))
    aggregate_failures do
      expect(form).to_not be_valid
      expect_to_include_domain_shared_error(form, :description, :invalid_long_sentence)
    end
  end
end
