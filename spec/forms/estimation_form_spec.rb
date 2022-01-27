# typed: false
require 'rails_helper'

describe EstimationForm do
  it do
    form = described_class.new(size: '3')
    expect(form).to be_valid
  end

  it do
    form = described_class.new(size: '?')
    aggregate_failures do
      expect(form).to be_valid
      expect(form.domain_objects[:size]).to eq Pbi::StoryPoint.unknown
    end
  end

  it do
    form = described_class.new(size: '6')
    aggregate_failures do
      expect(form).to_not be_valid
      expect_to_include_domain_error(form, :size, [:pbi, :invalid_story_point])
    end
  end
end
