# typed: false
require 'rails_helper'

RSpec.describe ScheduleIssueUsecase do
  let(:product) { create_product }
  let!(:issue_a) { add_issue(product.id) }
  let!(:issue_b) { add_issue(product.id) }
  let!(:issue_c) { add_issue(product.id) }
  let!(:issue_d) { add_issue(product.id) }
  let!(:issue_e) { add_issue(product.id) }
  let(:roles) { team_roles(:po) }

  before do
    plan = PlanRepository::AR.find_by_product_id(product.id)
    plan.update_scheduled(
      roles,
      release_list({
        'R1' => issue_list(issue_d.id),
        'R2' => issue_list(issue_a.id, issue_b.id),
        'R3' => issue_list,
      })
    )
    PlanRepository::AR.store(plan)
  end

  context 'add to some issues included release' do
    it do
      described_class.perform(product.id, roles, issue_c.id, 'R2', 1)

      plan = PlanRepository::AR.find_by_product_id(product.id)

      expect(plan.scheduled).to eq release_list({
        'R1' => issue_list(issue_d.id),
        'R2' => issue_list(issue_a.id, issue_c.id, issue_b.id),
        'R3' => issue_list,
      })
    end
  end

  context 'add to empty release' do
    it do
      described_class.perform(product.id, roles, issue_c.id, 'R3', 0)

      plan = PlanRepository::AR.find_by_product_id(product.id)

      expect(plan.scheduled).to eq release_list({
        'R1' => issue_list(issue_d.id),
        'R2' => issue_list(issue_a.id, issue_b.id),
        'R3' => issue_list(issue_c.id),
      })
    end
  end

  context 'append to tail' do
    it do
      described_class.perform(product.id, roles, issue_c.id, 'R1', 1)

      plan = PlanRepository::AR.find_by_product_id(product.id)

      expect(plan.scheduled).to eq release_list({
        'R1' => issue_list(issue_d.id, issue_c.id),
        'R2' => issue_list(issue_a.id, issue_b.id),
        'R3' => issue_list,
      })
    end
  end
end