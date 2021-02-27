# typed: false
require 'rails_helper'

RSpec.describe AppendScheduledIssueUsecase do
  let!(:product) { create_product }
  let(:roles) { team_roles(:po) }

  before do
    plan = PlanRepository::AR.find_by_product_id(product.id)
    plan.update_scheduled(
      roles,
      release_list({
        'R1' => issue_list,
        'R2' => issue_list,
      })
    )
    PlanRepository::AR.store(plan)
  end

  it do
    description = issue_description('ABC')

    issue_id = described_class.perform(product.id, roles, Issue::Types::Feature, description, 'R2')

    plan = PlanRepository::AR.find_by_product_id(product.id)
    expect(plan.scheduled).to eq release_list({
      'R1' => issue_list,
      'R2' => issue_list(issue_id)
    })
  end
end
