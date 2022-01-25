# typed: false
require 'rails_helper'

describe EstimationForm do
  it do
    form = described_class.new(point: '3')
    expect(form).to be_valid
  end

  it do
    form = described_class.new(point: '?')
    aggregate_failures do
      expect(form).to be_valid
      expect(form.domain_objects[:point]).to eq Pbi::StoryPoint.unknown
    end
  end

  it do
    form = described_class.new(point: '6')
    aggregate_failures do
      expect(form).to_not be_valid
      expect_to_include_domain_error(form, :point, [:pbi, :invalid_story_point])
    end
  end
end
