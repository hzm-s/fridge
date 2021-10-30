# typed: false
require 'domain_helper'

module Pbi
  RSpec.describe Pbi do
    let(:product_id) { Product::Id.create }
    let(:description) { l_sentence('A user story') }

    describe 'draft' do
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
  end
end
