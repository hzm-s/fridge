# typed: false
require 'rails_helper'

RSpec.describe ReleaseRepository::AR do
  let(:product) { create_product }

  let(:item_a) { add_issue(product.id) }
  let(:item_b) { add_issue(product.id) }
  let(:item_c) { add_issue(product.id) }
  let(:item_d) { add_issue(product.id) }
  let(:item_e) { add_issue(product.id) }

  let(:release) { Release::Release.create(product.id, 'MVP') }

  describe 'Add' do
    it do
      release.add_item(item_a.id)
      release.add_item(item_b.id)
      release.add_item(item_c.id)

      expect { described_class.store(release) }
        .to change { Dao::Release.count }.by(1)
        .and change { Dao::ReleaseItem.count }.by(3)

      aggregate_failures do
        rel = Dao::Release.eager_load(:items).last
        expect(rel.id).to eq release.id.to_s
        expect(rel.dao_product_id).to eq release.product_id.to_s
        expect(rel.title).to eq 'MVP'
        expect(rel.items.map(&:dao_issue_id)).to eq [item_a, item_b, item_c].map(&:id).map(&:to_s)
      end
    end
  end

  describe 'Update' do
    it do
      release.add_item(item_a.id)
      release.add_item(item_b.id)
      release.add_item(item_c.id)

      described_class.store(release)

      release.add_item(item_d.id)
      release.remove_item(item_b.id)
      release.add_item(item_e.id)

      expect { described_class.store(release) }
        .to change { Dao::Release.count }.by(0)
        .and change { Dao::ReleaseItem.count }.from(3).to(4)

      rel = Dao::Release.eager_load(:items).last
      expect(rel.items.map(&:dao_issue_id)).to eq [item_a, item_c, item_d, item_e].map(&:id).map(&:to_s)
    end
  end
end
