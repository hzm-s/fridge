# typed: false
require 'rails_helper'

module Pbi
  module Statuses
    RSpec.describe Preparation do
      let!(:product_id) { Product::Id.create }
      let!(:pbi) { Item.create(product_id, Content.new('PBI Item')) }

      describe '#update_by_prepartion' do
        context 'AcceptanceCriteria >= 1 and size == unknown' do
          it do
            pbi.update_acceptance_criteria(acceptance_criteria(%w(AC1)))
            status = described_class.update_by_prepartion(pbi)
            expect(status).to eq Preparation
          end
        end

        context 'AcceptanceCriteria >= 1 and size != unknown' do
          it do
            pbi.update_acceptance_criteria(acceptance_criteria(%w(AC1)))
            pbi.estimate_size(StoryPoint.new(3))
            status = described_class.update_by_prepartion(pbi)
            expect(status).to eq Ready
          end
        end

        context 'AcceptanceCriteria == 0 and size != unknown' do
          it do
            pbi.update_acceptance_criteria(acceptance_criteria([]))
            pbi.estimate_size(StoryPoint.new(3))
            status = described_class.update_by_prepartion(pbi)
            expect(status).to eq Preparation
          end
        end
      end
    end
  end
end
