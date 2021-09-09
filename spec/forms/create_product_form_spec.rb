# typed: false
require 'rails_helper'

RSpec.describe CreateProductForm do
  let(:valid) do
    { name: 'ABC', description: 'XYZ', roles: ['', 'scrum_master', ''] }
  end

  it do
    form = described_class.new(valid)
    expect(form).to be_valid
  end

  it do
    form = described_class.new(valid.merge(name: ''))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:name]).to include(I18n.t('errors.messages.blank'))
    end
  end

  it do
    form = described_class.new(valid.merge(name: 'a' * 51))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:name]).to include(I18n.t('domain.errors.shared.invalid_name'))
    end
  end

  it do
    form = described_class.new(valid.merge(description: ''))
    expect(form).to be_valid
  end

  it do
    form = described_class.new(valid.merge(description: 'a' * 201))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:description]).to include(I18n.t('errors.messages.too_long', count: 200))
    end
  end

  it do
    form = described_class.new(valid.merge(roles: ['', '', '']))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:roles]).to include(I18n.t('errors.messages.blank'))
    end
  end

  it do
    form = described_class.new(valid.merge(roles: ['product_owner', '', 'developer']))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:roles]).to include(I18n.t('domain.errors.team.invalid_multiple_roles'))
    end
  end
end
