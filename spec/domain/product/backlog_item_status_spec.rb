require 'rails_helper'

RSpec.describe Product::BacklogItemStatus do
  it do
    expect(Product::BacklogItemStatus::Preparation.to_s).to eq 'preparation'
  end
end
