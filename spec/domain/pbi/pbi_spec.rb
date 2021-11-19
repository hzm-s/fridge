# typed: false
require 'domain_helper'

module Pbi
  RSpec.describe Pbi do
    let(:product_id) { Product::Id.create }
    let(:description) { l_sentence('A user story') }
    let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }
    let(:point) { StoryPoint.new(8) }
    let(:dev_role) { team_roles(:dev) }
    let(:po_role) { team_roles(:po) }
    let(:sm_role) { team_roles(:sm) }

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
      let(:description) { l_sentence('Modified') }

      it do
        pbi.modify_description(description)
        expect(pbi.description).to eq description
      end

      it 'does NOT change status' do
        expect { pbi.modify_description(description) }.to_not change(pbi, :status)
      end
    end

    describe 'Prepare acceptance criteria' do
      let(:pbi) { described_class.draft(product_id, Types.from_string('feature'), description) }

      it do
        pbi.prepare_acceptance_criteria(criteria)
        expect(pbi.acceptance_criteria).to eq criteria
      end

      context 'when estimated' do
        before { pbi.estimate(dev_role, point) }

        it do
          pbi.prepare_acceptance_criteria(criteria)
          expect(pbi.status).to eq Statuses.from_string('ready')
        end
      end

      context 'when NOT estimated' do
        it do
          pbi.prepare_acceptance_criteria(criteria)
          expect(pbi.status).to eq Statuses.from_string('preparation')
        end
      end
    end

    describe 'Estimate size' do
      let(:pbi) { described_class.draft(product_id, Types.from_string('feature'), description) }

      it do
        pbi.estimate(dev_role, point)
        expect(pbi.size).to eq point
      end

      it { expect_activity_permission_error([po_role, sm_role]) { |role| pbi.estimate(role, point) } }

      context 'when acceptance criteria > 0' do
        before { pbi.prepare_acceptance_criteria(criteria) }

        it do
          pbi.estimate(dev_role, point)
          expect(pbi.status).to eq Statuses.from_string('ready')
        end
      end

      context 'when acceptance criteria == 0' do
        it do
          pbi.estimate(dev_role, point)
          expect(pbi.status).to eq Statuses.from_string('preparation')
        end
      end
    end
  end
end
