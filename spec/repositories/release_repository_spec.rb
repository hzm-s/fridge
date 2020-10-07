# typed: false
require 'rails_helper'

RSpec.describe ReleaseRepository::AR do
  let(:product) { create_product }

  let(:item_a) { add_issue(product.id) }
  let(:item_b) { add_issue(product.id) }
  let(:item_c) { add_issue(product.id) }
  let(:item_d) { add_issue(product.id) }
  let(:item_e) { add_issue(product.id) }

  describe 'Add' do
    it do
      release = Release::Release.create(product.id, 'MVP')

      expect { described_class.store(release) }
        .to change { Dao::Release.count }.by(1)

      aggregate_failures do
        rel = Dao::Release.last
        expect(rel.id).to eq release.id.to_s
        expect(rel.dao_product_id).to eq release.product_id.to_s
        expect(rel.title).to eq 'MVP'
      end
    end
  end

  describe 'Remove' do
    it do
      release = add_release(product.id, 'MVP')
      other_release = add_release(product.id, 'Other')

      described_class.remove(release.id)

      expect(Dao::Release.find_by(id: release.id)).to be_nil
      expect(Dao::Release.find_by(id: other_release.id)).to_not be_nil
    end
  end
end
