# typed: false
require 'domain_helper'

module Pbi
  RSpec.describe Pbi do
    let(:product_id) { Product::Id.create }
    let(:description) { l_sentence('A user story') }

    describe 'Draft' do
      it do
        type = Types.from_string('feature')
        pbi = described_class.draft(product_id, type, description)

        aggregate_failures do
          expect(pbi.id).to_not be_nil
          expect(pbi.product_id).to eq product_id
          expect(pbi.type).to eq type
          expect(pbi.status).to eq Statuses.from_string('preparation')
          expect(pbi.description).to eq description
          expect(pbi.size).to eq StoryPoint.unknown
          expect(pbi.acceptance_criteria).to be_empty
        end
      end
    end

    describe 'Modify description' do
      let(:pbi) { described_class.draft(product_id, Types.from_string('feature'), l_sentence('Origin')) }

      it do
        description = l_sentence('Modified')
        pbi.modify_description(description)
        expect(pbi.description).to eq description
      end
    end

    describe 'Prepare acceptance criteria' do
      let(:pbi) { described_class.draft(product_id, Types.from_string('feature'), description) }

      it do
        criteria = acceptance_criteria(%w(AC1 AC2 AC3))
        pbi.prepare_acceptance_criteria(criteria)
        expect(pbi.acceptance_criteria).to eq criteria
      end
    end
  end
end
