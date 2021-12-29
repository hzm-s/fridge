# typed: false
require 'rails_helper'

describe PbiRepository::AR do
  let!(:product) { create_product }

  describe 'Add' do
    it do
      pbi = Pbi::Pbi.draft(product.id, Pbi::Types.from_string('feature'), l_sentence('feat'))

      expect { described_class.store(pbi) }
        .to change(Dao::Pbi, :count).by(1)
        .and change(Dao::AcceptanceCriterion, :count).by(0)

      aggregate_failures do
        dao = Dao::Pbi.last
        expect(dao.id).to eq pbi.id.to_s
        expect(dao.dao_product_id).to eq pbi.product_id.to_s
        expect(dao.pbi_type).to eq pbi.type.to_s
        expect(dao.status).to eq pbi.status.to_s
        expect(dao.description).to eq pbi.description.to_s
        expect(dao.size).to be_nil
        expect(dao.criteria).to be_empty
      end
    end
  end

  describe 'Update' do
    let(:pbi) { Pbi::Pbi.draft(product.id, Pbi::Types.from_string('feature'), l_sentence('ABC')) }
    let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }

    it do
      pbi.prepare_acceptance_criteria(criteria)

      expect { described_class.store(pbi) }
        .to change(Dao::Pbi, :count).by(1)
        .and change(Dao::AcceptanceCriterion, :count).by(3)

      pbi.prepare_acceptance_criteria(criteria.remove(2))

      expect { described_class.store(pbi) }
        .to change(Dao::Pbi, :count).by(0)
        .and change(Dao::AcceptanceCriterion, :count).by(-1)

      aggregate_failures do
        dao = Dao::AcceptanceCriterion.all
        expect(dao.size).to eq 2
        expect(dao[0].content).to eq 'AC1'
        expect(dao[1].content).to eq 'AC3'
      end
    end
  end

  describe 'Remove' do
    before do
      Pbi::Pbi.draft(product.id, Pbi::Types.from_string('feature'), l_sentence('not remove')).tap do |pbi|
        pbi.prepare_acceptance_criteria(acceptance_criteria(%w(criterion)))
        described_class.store(pbi)
      end
    end

    it do
      pbi = Pbi::Pbi.draft(product.id, Pbi::Types.from_string('feature'), l_sentence('ABC'))
      pbi.prepare_acceptance_criteria(acceptance_criteria(%w(AC1 AC2 AC3)))
      described_class.store(pbi)

      described_class.remove(pbi.id)

      aggregate_failures do
        expect(Dao::Pbi.find_by(id: pbi.id.to_s)).to be_nil
        expect(Dao::AcceptanceCriterion.where(dao_pbi_id: pbi.id.to_s)).to be_empty
        expect(Dao::Pbi.count).to eq 1
        expect(Dao::AcceptanceCriterion.count).to eq 1
      end
    end
  end
end
