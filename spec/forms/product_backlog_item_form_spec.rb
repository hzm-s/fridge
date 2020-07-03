require 'rails_helper'

RSpec.describe ProductBacklogItemForm do
  let(:valid) do
    {
      product_id: 'dummy',
      content: 'ABC'
    }
  end

  it do
    form = described_class.new(valid)

    expect(form).to be_valid
  end

  it do
    form = described_class.new(valid.merge(product_id: nil))

    expect(form).to_not be_valid
  end

  it do
    form = described_class.new(valid.merge(content: ''))

    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:content]).to include(I18n.t('errors.messages.blank'))
    end
  end

  it do
    form = described_class.new(valid.merge(content: 'a' * 1000))

    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:content]).to include(I18n.t('domain.errors.messages.pbi.content'))
    end
  end
end
