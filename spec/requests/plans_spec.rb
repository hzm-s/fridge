# typed: false
require 'rails_helper'

RSpec.describe 'plans' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: roles) }
  let(:roles) { team_roles(:dev, :sm) }

  let!(:pbi_a) { add_pbi(product.id, release: 1).id }
  let!(:pbi_b) { add_pbi(product.id, release: 1).id }
  let!(:pbi_c) { add_pbi(product.id, release: 1).id }
  let!(:pbi_d) { add_pbi(product.id, release: 2).id }
  let!(:pbi_e) { add_pbi(product.id, release: 2).id }

  describe '#update' do
    before { sign_in(user_account) }

    context 'when change priority' do
      it do
        patch product_plan_path(product_id: product.id.to_s, format: :json),
          params: { item_id: pbi_c.to_s, from: '1', to: '1', to_index: 1 }

        pbl = ProductBacklogQuery.call(product.id.to_s)

        aggregate_failures do
          expect(pbl.releases[0].items.map(&:id)).to eq [pbi_a, pbi_c, pbi_b].map(&:to_s)
          expect(pbl.releases[1].items.map(&:id)).to eq [pbi_d, pbi_e].map(&:to_s)
        end
      end
    end

    context 'when reschedule' do
      it do
        patch product_plan_path(product_id: product.id.to_s, format: :json),
          params: { item_id: pbi_e.to_s, from: '2', to: '1', to_index: 2 }

        pbl = ProductBacklogQuery.call(product.id.to_s)

        aggregate_failures do
          expect(pbl.releases[0].items.map(&:id)).to eq [pbi_a, pbi_b, pbi_e, pbi_c].map(&:to_s)
          expect(pbl.releases[1].items.map(&:id)).to eq [pbi_d].map(&:to_s)
        end
      end
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { patch product_plan_path(product_id: 1, format: :json) } }
end
