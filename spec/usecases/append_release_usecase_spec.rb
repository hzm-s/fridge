# typed: false
require 'rails_helper'

RSpec.describe AppendReleaseUsecase do
  let(:product) { create_product }
  let(:roles) { team_roles(:po) }

  it do
    described_class.perform(roles, product.id, name('MVP'))

    plan = PlanRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect(plan.release_of(2).title.to_s).to eq 'MVP'
      expect(plan.release_of(2).items).to eq pbi_list
    end
  end

  it do
    described_class.perform(roles, product.id, nil)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    expect(plan.release_of(2).title.to_s).to eq 'Release#2'
  end
end
