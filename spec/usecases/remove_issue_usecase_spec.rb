# typed: false
require 'rails_helper'

RSpec.describe RemoveIssueUsecase do
  let(:product) { create_product }
  let(:roles) { team_roles(:po) }

  it do
    issue_a = plan_issue(product.id).id
    issue_b = plan_issue(product.id).id
    issue_c = plan_issue(product.id).id

    described_class.perform(product.id, roles, issue_b)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect { IssueRepository::AR.find_by_id(issue_b) }.to raise_error Issue::NotFound
      expect(plan.recent_release.issues).to eq issue_list(issue_a, issue_c)
    end
  end
end
