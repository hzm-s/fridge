# typed: false
require 'rails_helper'

describe PlanRepository::AR do
  let(:product_id) { Product::Id.create }
  let(:other_product_id) { Product::Id.create }
  let!(:pbi_a) { Pbi::Id.create }
  let!(:pbi_b) { Pbi::Id.create }
  let!(:pbi_c) { Pbi::Id.create }
  let!(:po_role) { team_roles(:po) }

  before do
    Dao::Product.create!(id: product_id.to_s, name: 'p')
    Dao::Product.create!(id: other_product_id.to_s, name: 'other')
  end

  let(:plan) { Plan::Plan.create(product_id) }

  let!(:other_release_dao) do
    Dao::Release.create!(
      dao_product_id: other_product_id.to_s,
      number: 2,
      items: [Pbi::Id.create]
    )
  end

  describe 'Append' do
    it do
      plan.release_of(1).tap do |r|
        r.plan_item(pbi_a)
        r.plan_item(pbi_b)
        r.plan_item(pbi_c)
        r.modify_title(name('R1'))
        plan.update_release(po_role, r)
      end

      expect { described_class.store(plan) }
        .to change { Dao::Release.count }.from(1).to(2)

      stored = described_class.find_by_product_id(product_id)

      aggregate_failures do
        expect(stored.releases.size).to eq 1
        expect(stored.release_of(1).title.to_s).to eq 'R1'
        expect(stored.release_of(1).items).to eq pbi_list(pbi_a, pbi_b, pbi_c)
      end
    end
  end

  describe 'Update' do
    it do
      plan.release_of(1).tap do |r|
        r.plan_item(pbi_b)
        r.modify_title(name('R1'))
        plan.update_release(po_role, r)
      end
      described_class.store(plan)

      plan.release_of(1).tap do |r|
        r.modify_title(name('MVP'))
        plan.update_release(po_role, r)
      end

      plan.append_release(po_role)
      plan.release_of(2).tap do |r|
        r.plan_item(pbi_c)
        r.plan_item(pbi_a)
        plan.update_release(po_role, r)
      end

      expect { described_class.store(plan) }
        .to change { Dao::Release.count }.from(2).to(3)

      stored = described_class.find_by_product_id(product_id)

      aggregate_failures do
        expect(stored.releases.size).to eq 2
        expect(stored.release_of(1).title.to_s).to eq 'MVP'
        expect(stored.release_of(1).items).to eq pbi_list(pbi_b)
        expect(stored.release_of(2).title.to_s).to eq 'Release#2'
        expect(stored.release_of(2).items).to eq pbi_list(pbi_c, pbi_a)
      end
    end
  end

  describe 'Remove' do
    it do
      plan.release_of(1).tap do |r|
        r.plan_item(pbi_a)
        plan.update_release(po_role, r)
      end

      plan.append_release(po_role)

      plan.append_release(po_role)
      plan.release_of(3).tap do |r|
        r.plan_item(pbi_b)
        r.plan_item(pbi_c)
        plan.update_release(po_role, r)
      end

      described_class.store(plan)

      plan.remove_release(po_role, 2)

      expect { described_class.store(plan) }
        .to change { Dao::Release.count }.from(4).to(3)

      stored = described_class.find_by_product_id(product_id)

      aggregate_failures do
        expect(other_release_dao.reload).to_not be_nil

        expect(stored.releases.size).to eq 2
        expect(stored.release_of(1).items).to eq pbi_list(pbi_a)
        expect(stored.release_of(3).items).to eq pbi_list(pbi_b, pbi_c)
      end
    end
  end
end
