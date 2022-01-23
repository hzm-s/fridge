# typed: false
require 'rails_helper'

describe ReleaseForm do
  let(:valid) do
    { title: 'MVP' }
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
      expect(form.domain_objects[:title]).to be_nil
    end
  end

  it do
    form = described_class.new(valid.merge(title: 'a' * 51))
    aggregate_failures do
      expect(form).to_not be_valid
      expect_to_include_domain_error(form, :title, [:shared, :invalid_name])
    end
  end
end
