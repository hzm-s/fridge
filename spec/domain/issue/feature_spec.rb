# typed: false
require 'domain_helper'

module Issue
  RSpec.describe Feature do
    let(:product_id) { Product::Id.create }
    let(:description) { pbi_description('A user story') }

    describe 'create' do
      let(:pbi) { described_class.create(product_id, description) }

      it do
        aggregate_failures do
          expect(pbi.id).to_not be_nil
          expect(pbi.product_id).to eq product_id
          expect(pbi.status).to eq Statuses::Preparation
          expect(pbi.description).to eq description
          expect(pbi.size).to eq StoryPoint.unknown
          expect(pbi.acceptance_criteria).to be_empty
        end
      end
    end

    describe 'Modify description' do
      let(:pbi) { described_class.create(product_id, pbi_description('Origin')) }

      it do
        new_desc = pbi_description('Modified')
        pbi.modify_description(new_desc)
        expect(pbi.description).to eq new_desc
      end
    end

    describe 'Acceptance criteria' do
      let(:pbi) { described_class.create(product_id, description) }

      it do
        criteria = acceptance_criteria(%w(AC1 AC2 AC3))
        pbi.update_acceptance_criteria(criteria)
        expect(pbi.acceptance_criteria).to eq criteria
      end
    end

    describe 'Update Status' do
      let(:pbi) { described_class.create(product_id, description) }

      it do

        pbi.modify_description(pbi_description('NEW user story'))
        expect(pbi.status).to eq Statuses::Preparation

        pbi.update_acceptance_criteria(acceptance_criteria(%w(AC1)))
        expect(pbi.status).to eq Statuses::Preparation

        pbi.estimate(StoryPoint.new(3))
        expect(pbi.status).to eq Statuses::Ready

        pbi.update_acceptance_criteria(acceptance_criteria([]))
        expect(pbi.status).to eq Statuses::Preparation

        pbi.update_acceptance_criteria(acceptance_criteria(%w(AC1 AC2 AC3)))
        pbi.start_development
        expect(pbi.status).to eq Statuses::Wip

        pbi.estimate(StoryPoint.new(5))
        expect(pbi.size).to eq StoryPoint.new(3)

        pbi.abort_development
        expect(pbi.status).to eq Statuses::Ready
      end
    end
  end
end
