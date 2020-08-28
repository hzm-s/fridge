# typed: false
require 'rails_helper'

RSpec.describe PbiRepository::AR do
  let!(:product) { create_product }

  describe '#create' do
    it do
      pbi = Pbi::Pbi.create(product.id, Pbi::Description.new('ABC'))
      expect { described_class.add(pbi) }
        .to change { Dao::Pbi.count }.by(1)
    end
  end

  describe '#update' do
    it do
      pbi = add_pbi(product.id)
      pbi.update_acceptance_criteria(acceptance_criteria(%w(AC1 AC2)))

      expect { described_class.update(pbi) }
        .to change { Dao::Pbi.count }.by(0)
        .and change { Dao::AcceptanceCriterion.count }.by(2)

      criteria = Dao::AcceptanceCriterion.all
      expect(criteria.map(&:content)).to match_array acceptance_criteria(%w(AC1 AC2).to_a)
    end

    it do
      pbi = add_pbi(product.id, acceptance_criteria: %w(AC1 AC2 AC3 AC4))
      pbi.update_acceptance_criteria(acceptance_criteria(%w(AC1 AC2 AC3)))

      expect { described_class.update(pbi) }
        .to change { Dao::Pbi.count }.by(0)
        .and change { Dao::AcceptanceCriterion.count }.by(-1)

      criteria = Dao::AcceptanceCriterion.all
      expect(criteria.map(&:content)).to match_array acceptance_criteria(%w(AC1 AC2 AC3).to_a)
    end

    it do
      pbi = add_pbi(product.id, acceptance_criteria: %w(ac1))
      pbi.estimate(Pbi::StoryPoint.new(5))

      described_class.update(pbi)
      updated = described_class.find_by_id(pbi.id)

      expect(updated.status).to eq pbi.status
    end
  end

  describe '#delete' do
    it do
      pbi = add_pbi(product.id, acceptance_criteria: %w(ac1 ac2 ac3))

      expect { described_class.delete(pbi.id) }
        .to change { Dao::Pbi.count }.by(-1)
        .and change { Dao::AcceptanceCriterion.count }.by(-3)
    end
  end
end
