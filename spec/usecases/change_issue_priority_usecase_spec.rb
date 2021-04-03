# typed: false
require 'rails_helper'

RSpec.describe ChangeIssuePriorityUsecase do
  let(:product) { create_product }
  let!(:issue_a) { plan_issue(product.id).id }
  let!(:issue_b) { plan_issue(product.id).id }
  let!(:issue_c) { plan_issue(product.id).id }
  let(:roles) { team_roles(:po) }

  it do
    described_class.perform(product.id, roles, issue_a, 2)

    plan = plan_of(product.id)

    expect(plan.release_of(1).issues).to eq issue_list(issue_b, issue_c, issue_a)
  end
end
