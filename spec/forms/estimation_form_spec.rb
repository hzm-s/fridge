# typed: false
require 'rails_helper'

describe EstimationForm do
  it do
    form = described_class.new(point: 3)
    expect(form).to be_valid
  end

  it do
    form = described_class.new(point: 6)
    expect(form).to_not be_valid
    expect_to_include_domain_error(form, :point, [:pbi, :invalid_story_point])
  end
end
