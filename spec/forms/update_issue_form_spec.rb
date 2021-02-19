# typed: false
require 'rails_helper'

RSpec.describe UpdateIssueForm do
  let(:valid) do
    {
      type: 'feature',
      description: 'ABC',
    }
  end

  it do
    form = described_class.new(valid)
    expect(form).to be_valid
  end

  it do
    form = described_class.new(valid.merge(type: ''))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:type]).to include(I18n.t('errors.messages.blank'))
    end
  end

  it do
    form = described_class.new(valid.merge(type: 'epic'))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:type]).to include(I18n.t('domain.errors.issue.invalid_type'))
    end
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
      expect(form.errors[:description]).to include(I18n.t('domain.errors.issue.invalid_description'))
    end
  end
end
