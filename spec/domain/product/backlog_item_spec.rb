require 'rails_helper'

describe Product::BacklogItem do
  let(:content) { Product::BacklogItemContent.new('ABC') }

  describe '.new' do
    it do
      pbi = described_class.new(content)
      
      aggregate_failures do
        expect(pbi.id).to_not be_nil
        expect(pbi.content).to eq content
      end
    end

    it do
      pbi = described_class.new(content)
      expect(pbi.status).to eq Product::BacklogItemStatus::Preparation
    end
  end
end
