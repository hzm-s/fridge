# typed: false
require 'rails_helper'

RSpec.describe 'plans' do
  let!(:user_account) { sign_up }
  let!(:product) { create_product(person: user_account.person_id, roles: roles) }
  let(:roles) { team_roles(:dev, :sm) }

  before do
    sign_in(user_account)
  end

  let!(:issue_a) { add_issue(product.id) }
  let!(:issue_b) { add_issue(product.id) }
  let!(:issue_c) { add_issue(product.id) }
  let!(:issue_d) { add_issue(product.id) }
  let!(:issue_e) { add_issue(product.id) }
  let!(:issue_f) { add_issue(product.id) }

  before do
    plan = PlanRepository::AR.find_by_product_id(product.id)
    plan.update_scheduled(
      roles,
      release_list({
        'R1' => issue_list(issue_c.id, issue_d.id),
        'R2' => issue_list(issue_e.id, issue_f.id),
      })
    )
    PlanRepository::AR.store(plan)
  end

  describe '#update' do
    context 'when schedule issue' do
      it do
        patch product_plan_path(product_id: product.id.to_s, format: :json),
          params: { issue_id: issue_b.id.to_s, to: 'R1', to_index: 1 }

        plan = PlanRepository::AR.find_by_product_id(product.id)
        expect(plan.scheduled).to eq release_list({
          'R1' => issue_list(issue_c.id, issue_b.id, issue_d.id),
          'R2' => issue_list(issue_e.id, issue_f.id),
        })
      end
    end

    context 'when change priority' do
      it do
        patch product_plan_path(product_id: product.id.to_s, format: :json),
          params: { issue_id: issue_c.id.to_s, from: 'R1', to: 'R1', to_index: 1 }

        plan = PlanRepository::AR.find_by_product_id(product.id)
        expect(plan.scheduled).to eq release_list({
          'R1' => issue_list(issue_d.id, issue_c.id),
          'R2' => issue_list(issue_e.id, issue_f.id),
        })
      end
    end

    context 'when change relase' do
      it do
        patch product_plan_path(product_id: product.id.to_s, format: :json),
          params: { issue_id: issue_f.id.to_s, from: 'R2', to: 'R1', to_index: 0 }

        plan = PlanRepository::AR.find_by_product_id(product.id)
        expect(plan.scheduled).to eq release_list({
          'R1' => issue_list(issue_f.id, issue_c.id, issue_d.id),
          'R2' => issue_list(issue_e.id),
        })
      end
    end
  end
end
