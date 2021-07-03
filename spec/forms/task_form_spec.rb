# typed: false
require 'rails_helper'

RSpec.describe TaskForm do
  let(:valid) do
    {
      content: 'Desgin API'
    }
  end

  it do
    form = described_class.new(valid)
    expect(form).to be_valid
  end

  it do
    form = described_class.new(valid.merge(content: ''))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:content]).to include(I18n.t('errors.messages.too_short', count: 2))
    end
  end

  it do
    form = described_class.new(valid.merge(content: 'a'))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:content]).to include(I18n.t('errors.messages.too_short', count: 2))
    end
  end

  it do
    form = described_class.new(valid.merge(content: 'a' * 51))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:content]).to include(I18n.t('errors.messages.too_long', count: 50))
    end
  end
end
