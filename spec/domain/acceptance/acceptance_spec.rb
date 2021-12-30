# typed: false
require 'domain_helper'

module Acceptance
  describe Acceptance do
    let(:pbi_id) { Pbi::Id.create }
    let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }

    describe 'Prepare' do
      it do
        acceptance = described_class.prepare(pbi_id, criteria)
        aggregate_failures do
          expect(acceptance.pbi_id).to eq pbi_id
          expect(acceptance.criteria).to eq criteria
          expect(acceptance.status).to eq Statuses.from_string('not_accepted')
        end
      end
    end

    describe 'Satisfy' do
      it do
        acceptance = described_class.prepare(pbi_id, criteria)

        acceptance.satisfy(3)
        acceptance.satisfy(2)
        acceptance.satisfy(3)
        expect(acceptance.status).to eq Statuses.from_string('not_accepted')

        acceptance.satisfy(1)
        expect(acceptance.status).to eq Statuses.from_string('accepted')
      end
    end
  end
end
