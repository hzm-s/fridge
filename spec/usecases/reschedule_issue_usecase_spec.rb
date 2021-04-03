# typed: false
require 'rails_helper'

RSpec.describe RescheduleIssueUsecase do
  let(:product) { create_product }
  let!(:issue_a) { plan_issue(product.id, release: 1).id }
  let!(:issue_b) { plan_issue(product.id, release: 1).id }
  let!(:issue_c) { plan_issue(product.id, release: 2).id }
  let!(:issue_d) { plan_issue(product.id, release: 2).id }
  let!(:issue_e) { plan_issue(product.id, release: 2).id }
  let(:roles) { team_roles(:po) }

  before do
    append_release(product.id)
  end

  it do
    described_class.perform(product.id, roles, issue_c, 1, 1)

    plan = plan_of(product.id)
    aggregate_failures do
      expect(plan.release_of(1).issues).to eq issue_list(issue_a, issue_c, issue_b)
      expect(plan.release_of(2).issues).to eq issue_list(issue_d, issue_e)
      expect(plan.release_of(3).issues).to eq issue_list
    end
  end

  it do
    described_class.perform(product.id, roles, issue_d, 3, 0)

    plan = plan_of(product.id)
    aggregate_failures do
      expect(plan.release_of(1).issues).to eq issue_list(issue_a, issue_b)
      expect(plan.release_of(2).issues).to eq issue_list(issue_c, issue_e)
      expect(plan.release_of(3).issues).to eq issue_list(issue_d)
    end
  end

  it do
    described_class.perform(product.id, roles, issue_c, 1, 2)

    plan = plan_of(product.id)
    aggregate_failures do
      expect(plan.release_of(1).issues).to eq issue_list(issue_a, issue_b, issue_c)
      expect(plan.release_of(2).issues).to eq issue_list(issue_d, issue_e)
      expect(plan.release_of(3).issues).to eq issue_list
    end
  end
end
