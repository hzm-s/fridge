# typed: false
require 'rails_helper'

RSpec.describe ProductBacklogItemRepository::AR do
  let!(:product) { create_product }

  describe '#create' do
    it do
      pbi = Pbi::Item.create(product.id, Pbi::Content.new('ABC'))
      expect { described_class.add(pbi) }
        .to change { Dao::ProductBacklogItem.count }.by(1)
    end
  end

  describe '#update' do
    it do
      pbi = add_pbi(product.id)
      pbi.add_acceptance_criterion(Pbi::AcceptanceCriterion.new('ac1'))
      pbi.add_acceptance_criterion(Pbi::AcceptanceCriterion.new('ac2'))

      expect { described_class.update(pbi) }
        .to change { Dao::ProductBacklogItem.count }.by(0)
        .and change { Dao::AcceptanceCriterion.count }.by(2)
    end

    it do
      pbi = add_pbi(product.id, acceptance_criteria: %w(ac1 ac2 ac3 ac4))
      pbi.remove_acceptance_criterion(Pbi::AcceptanceCriterion.new('ac4'))

      expect { described_class.update(pbi) }
        .to change { Dao::ProductBacklogItem.count }.by(0)
        .and change { Dao::AcceptanceCriterion.count }.by(-1)
    end

    it do
      pbi = add_pbi(product.id, acceptance_criteria: %w(ac1))
      pbi.estimate_size(Pbi::StoryPoint.new(5))

      described_class.update(pbi)
      updated = described_class.find_by_id(pbi.id)

      expect(updated.status).to eq pbi.status
    end
  end

  describe '#delete' do
    it do
      pbi = add_pbi(product.id)
      add_acceptance_criteria(pbi, %w(ac1 ac2 ac3))

      expect { described_class.delete(pbi.id) }
        .to change { Dao::ProductBacklogItem.count }.by(-1)
        .and change { Dao::AcceptanceCriterion.count }.by(-3)
    end
  end
end
