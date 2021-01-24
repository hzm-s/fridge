# typed: false
require 'rails_helper'

RSpec.describe ChangeReleaseNameUsecase do
  let(:product) { create_product }
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
    described_class.perform(product.id, roles, '2nd Release', 'R2')

    plan = PlanRepository::AR.find_by_product_id(product.id)

    expect(plan.scheduled).to eq release_list({
      'R1' => issue_list,
      '2nd Release' => issue_list,
    })
  end

  it do
    expect { described_class.perform(product.id, roles, 'R1', 'R2') }
      .to raise_error Plan::DuplicatedReleaseName
  end
end
