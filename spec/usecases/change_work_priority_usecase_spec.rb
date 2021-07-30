# typed: false
require 'rails_helper'

RSpec.describe ChangeWorkPriorityUsecase do
  let(:product) { create_product }
  let!(:issue_a) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:issue_b) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:issue_c) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let(:roles) { team_roles(:po) }

  it do
    described_class.perform(product.id, roles, issue_b.id, 0)

    sprint = SprintRepository::AR.current(product.id)

    expect(sprint.issues).to eq issue_list(issue_b.id, issue_a.id, issue_c.id)
  end
end
