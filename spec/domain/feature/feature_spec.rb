# typed: false
require 'domain_helper'

module Feature
  RSpec.describe Feature do
    let(:product_id) { Product::Id.create }

    describe 'create' do
      let(:feature) { described_class.create(product_id, 'A user story') }

      it do
        aggregate_failures do
          expect(feature.product_id).to eq product_id
          expect(feature.id).to_not be_nil
          expect(feature.description).to eq 'A user story'
        end
      end

      it do
        expect(feature.size).to eq StoryPoint.unknown
      end

      it do
        expect(feature.acceptance_criteria).to be_empty
      end
    end

    describe 'Modify description' do
      let(:feature) { described_class.create(product_id, 'Origin') }

      it do
        feature.modify_description('Modified')
        expect(feature.description).to eq 'Modified'
      end
    end

    describe 'Acceptance criteria' do
      let(:feature) { described_class.create(product_id, 'A user story') }

      it do
        criteria = acceptance_criteria(%w(AC1 AC2 AC3))
        feature.update_acceptance_criteria(criteria)
        expect(feature.acceptance_criteria).to eq criteria
      end
    end

    describe 'Update Status' do
      let(:feature) { described_class.create(product_id, 'A user story') }

      it do
        expect(feature.status).to eq Statuses::Preparation

        feature.modify_description('NEW user story')
        expect(feature.status).to eq Statuses::Preparation

        feature.update_acceptance_criteria(acceptance_criteria(%w(AC1)))
        expect(feature.status).to eq Statuses::Preparation

        feature.estimate_size(StoryPoint.new(3))
        expect(feature.status).to eq Statuses::Ready

        feature.assign
        expect(feature.status).to eq Statuses::Wip

        feature.estimate_size(StoryPoint.new(5))
        expect(feature.size).to eq StoryPoint.new(3)

        feature.cancel_assignment
        expect(feature.status).to eq Statuses::Ready
      end
    end
  end
end
