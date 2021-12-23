# typed: false
require 'rails_helper'

RSpec.describe 'current_sprint/:product_id/work_priority' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: team_roles(:po)) }

  describe 'Update' do
    before { sign_in(user_account) }

    let!(:pbi_a) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
    let!(:pbi_b) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
    let!(:pbi_c) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
    let(:sprint) { SprintRepository::AR.current(product.id) }

    it do
      patch current_sprint_work_priority_path(product_id: product.id.to_s, format: :json),
        params: { item_id: pbi_c.id.to_s, to_index: 0 }

      sbl = SprintBacklogQuery.call(sprint.id)

      expect(sbl.items.map(&:pbi_id)).to eq [pbi_c.id, pbi_a.id, pbi_b.id].map(&:to_s)
    end
  end

  it_behaves_like('sign_in_guard') { let(:r) { patch current_sprint_work_priority_path(product_id: 1, format: :json) } }
end
