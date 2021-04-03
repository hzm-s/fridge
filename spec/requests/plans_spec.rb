# typed: false
require 'rails_helper'

RSpec.describe 'plans' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: roles) }
  let(:roles) { team_roles(:dev, :sm) }

  before do
    sign_in(user_account)
  end

  let!(:issue_a) { plan_issue(product.id, release: 1).id }
  let!(:issue_b) { plan_issue(product.id, release: 1).id }
  let!(:issue_c) { plan_issue(product.id, release: 1).id }
  let!(:issue_d) { plan_issue(product.id, release: 2).id }
  let!(:issue_e) { plan_issue(product.id, release: 2).id }

  describe '#update' do
    context 'when change priority' do
      it do
        patch product_plan_path(product_id: product.id.to_s, format: :json),
          params: { issue_id: issue_c.to_s, from: '1', to: '1', to_index: 1 }

        pbl = ProductBacklogQuery.call(product.id.to_s)

        aggregate_failures do
          expect(pbl.releases[0].issues.map(&:id)).to eq [issue_a, issue_c, issue_b].map(&:to_s)
          expect(pbl.releases[1].issues.map(&:id)).to eq [issue_d, issue_e].map(&:to_s)
        end
      end
    end

    context 'when reschedule' do
      it do
        patch product_plan_path(product_id: product.id.to_s, format: :json),
          params: { issue_id: issue_e.to_s, from: '2', to: '1', to_index: 2 }

        pbl = ProductBacklogQuery.call(product.id.to_s)

        aggregate_failures do
          expect(pbl.releases[0].issues.map(&:id)).to eq [issue_a, issue_b, issue_e, issue_c].map(&:to_s)
          expect(pbl.releases[1].issues.map(&:id)).to eq [issue_d].map(&:to_s)
        end
      end
    end
  end
end
