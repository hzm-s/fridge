require 'rails_helper'

RSpec.describe ProductBacklogItemRepository::AR do
  let!(:product) { create_product }

  describe '#create' do
    it do
      pbi = Pbi::Item.create(product.id, Pbi::Content.from_string('ABC'))
      expect { described_class.add(pbi) }
        .to change { Dao::ProductBacklogItem.count }.by(1)
    end
  end

  describe '#update' do
    it do
      pbi = add_pbi(product.id)
      pbi.add_acceptance_criterion('ac1')
      pbi.add_acceptance_criterion('ac2')

      expect { described_class.update(pbi) }
        .to change { Dao::ProductBacklogItem.count }.by(0)
        .and change { Dao::AcceptanceCriterion.count }.by(2)
    end

    it do
      pbi = add_pbi(product.id, acceptance_criteria: %w(ac1 ac2 ac3 ac4))
      pbi.remove_acceptance_criterion(4)

      expect { described_class.update(pbi) }
        .to change { Dao::ProductBacklogItem.count }.by(0)
        .and change { Dao::AcceptanceCriterion.count }.by(-1)
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
