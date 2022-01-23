# typed: false
require 'rails_helper'

describe TaskForm do
  let(:valid) do
    { content: 'Desgin API' }
  end

  it do
    form = described_class.new(valid)
    expect(form).to be_valid
  end

  it do
    form = described_class.new(valid.merge(content: ''))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:content]).to include(I18n.t('errors.messages.blank'))
    end
  end

  it do
    form = described_class.new(valid.merge(content: 'a' * 101))
    aggregate_failures do
      expect(form).to_not be_valid
      expect_to_include_domain_error(form, :content, [:shared, :invalid_short_sentence])
    end
  end
end
