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
    form = described_class.new(valid.merge(content: 'a' * 101))
    expect(form).to_not be_valid
    expect(form.errors[:content]).to include(I18n.t('domain.errors.shared.invalid_short_sentence'))
  end
end
