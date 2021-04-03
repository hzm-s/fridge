# typed: false
require 'rails_helper'

RSpec.describe ReleaseForm do
  let(:valid) do
    {
      description: 'MVP'
    }
  end

  it do
    form = described_class.new(valid)
    expect(form).to be_valid
  end

  it do
    form = described_class.new(valid.merge(description: 'a' * 101))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:description]).to include(I18n.t('errors.messages.too_long', count: 100))
    end
  end
end
