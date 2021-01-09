# typed: false
require 'rails_helper'

RSpec.describe TeamMemberForm do
  let(:valid) do
    { roles: ['', 'scrum_master', ''] }
  end

  it do
    form = described_class.new(valid)
    expect(form).to be_valid
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
