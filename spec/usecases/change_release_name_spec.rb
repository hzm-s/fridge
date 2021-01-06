# typed: false
require 'rails_helper'

RSpec.describe ChangeReleaseNameUsecase do
  let(:product) { create_product }

  before do
    plan = PlanRepository::AR.find_by_product_id(product.id)
    plan.update_scheduled(
      release_list({
        'R1' => issue_list,
        'R2' => issue_list,
      })
    )
    PlanRepository::AR.store(plan)
  end

  it do
    described_class.perform(product.id, '2nd Release', 'R2')

    plan = PlanRepository::AR.find_by_product_id(product.id)

    expect(plan.scheduled).to eq release_list({
      'R1' => issue_list,
      '2nd Release' => issue_list,
    })
  end
end