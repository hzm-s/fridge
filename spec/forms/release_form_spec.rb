# typed: false
require 'rails_helper'

RSpec.describe ReleaseForm do
  let(:valid) do
    {
      title: 'MVP'
    }
  end

  it do
    form = described_class.new(valid)
    expect(form).to be_valid
  end

  it do
    form = described_class.new(valid.merge(title: ''))
    aggregate_failures do
      expect(form).to be_valid
      expect(form.title).to be_nil
    end
  end

  it do
    form = described_class.new(valid.merge(title: 'a' * 101))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:title]).to include(I18n.t('errors.messages.too_long', count: 100))
    end
  end
end
