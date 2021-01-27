# typed: false
require 'rails_helper'

RSpec.describe RemoveReleaseUsecase do
  let(:product) { create_product }
  let(:issue_a) { add_issue(product.id).id }
  let(:issue_b) { add_issue(product.id).id }
  let(:roles) { team_roles(:po) }

  before do
    plan = PlanRepository::AR.find_by_product_id(product.id)
    plan.update_scheduled(
      roles,
      release_list({
        'R1' => issue_list(issue_a),
        'R2' => issue_list,
      })
    )
    plan.update_pending(issue_list(issue_b))
    PlanRepository::AR.store(plan)
  end

  it do
    described_class.perform(product.id, roles, 'R2')

    plan = PlanRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect(plan.scheduled).to eq release_list({ 'R1' => issue_list(issue_a) })
      expect(plan.pending).to eq issue_list(issue_b)
    end
  end

  it do
    expect { described_class.perform(product.id, roles, 'R1') }
      .to raise_error(Plan::ReleaseIsNotEmpty)
  end
end
