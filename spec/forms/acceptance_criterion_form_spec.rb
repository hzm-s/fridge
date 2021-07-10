# typed: false
require 'rails_helper'

RSpec.describe AcceptanceCriterionForm do
  let(:valid) do
    { content: 'Acceptance criterion' }
  end

  it do
    form = described_class.new(valid)
    expect(form).to be_valid
  end

  it do
    form = described_class.new(valid.merge(content: 'a' * 2))
    expect(form).to_not be_valid
    expect(form.errors[:content]).to include(I18n.t('errors.messages.too_short', count: 3))
  end

  it do
    form = described_class.new(valid.merge(content: 'a' * 501))
    expect(form).to_not be_valid
    expect(form.errors[:content]).to include(I18n.t('errors.messages.too_long', count: 500))
  end
end
