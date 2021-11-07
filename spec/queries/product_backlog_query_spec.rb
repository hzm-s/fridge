# typed: false
require 'rails_helper'

describe ProductBacklogQuery do
  let!(:product) { create_product }
  let(:roles) { team_roles(:po) }

  context 'PBL contains releases' do
    let!(:pbi_a) { add_pbi(product.id, release: 1).id }
    let!(:pbi_b) { add_pbi(product.id, release: 1).id }
    let!(:pbi_c) { add_pbi(product.id, release: 2).id }
    let!(:pbi_d) { add_pbi(product.id, release: 2).id }
    let!(:pbi_e) { add_pbi(product.id, release: 2).id }

    before do
      append_release(product.id)
      update_release(product.id, 2) do |r|
        r.modify_title(name('2nd'))
      end
    end

    it do
      pbl = described_class.call(product.id.to_s)

      aggregate_failures do
        expect(pbl.releases[0].number).to eq 1
        expect(pbl.releases[0].title).to eq 'Release#1'
        expect(pbl.releases[0].items.map(&:id)).to eq [pbi_a, pbi_b].map(&:to_s)
        expect(pbl.releases[0]).to_not be_can_remove
        expect(pbl.releases[1].number).to eq 2
        expect(pbl.releases[1].title).to eq '2nd'
        expect(pbl.releases[1].items.map(&:id)).to eq [pbi_c, pbi_d, pbi_e].map(&:to_s)
        expect(pbl.releases[1]).to_not be_can_remove
        expect(pbl.releases[2].number).to eq 3
        expect(pbl.releases[0].title).to eq 'Release#1'
        expect(pbl.releases[2].items).to be_empty
        expect(pbl.releases[2]).to be_can_remove
      end
    end
  end

  context 'contains only empty release' do
    it do
      pbl = described_class.call(product.id.to_s)

      expect(pbl.releases[0]).to_not be_can_remove
    end
  end
end
