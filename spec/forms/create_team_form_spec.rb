# typed: false
require 'rails_helper'

RSpec.describe CreateTeamForm do
  let(:valid) { { name: 'ABC', role: 'developer' } }

  it do
    form = described_class.new(valid)
    expect(form).to be_valid
  end

  it do
    form = described_class.new(valid.merge(name: ''))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:name]).to include I18n.t('errors.messages.blank')
    end
  end

  it do
    form = described_class.new(valid.merge(name: 'a' * 51))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:name]).to include I18n.t('errors.messages.too_long', count: 50)
    end
  end

  it do
    form = described_class.new(valid.merge(role: ''))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:role]).to include I18n.t('errors.messages.blank')
    end
  end

  it do
    form = described_class.new(valid.merge(role: 'leader'))
    aggregate_failures do
      expect(form).to_not be_valid
      expect(form.errors[:role]).to include I18n.t('domain.errors.team.invalid_role')
    end
  end
end
