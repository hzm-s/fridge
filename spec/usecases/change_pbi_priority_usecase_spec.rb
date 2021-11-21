# typed: false
require 'rails_helper'

RSpec.describe ChangePbiPriorityUsecase do
  let(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id).id }
  let!(:pbi_b) { add_pbi(product.id).id }
  let!(:pbi_c) { add_pbi(product.id).id }
  let(:roles) { team_roles(:po) }

  it do
    described_class.perform(product.id, roles, pbi_a, 2)

    plan = plan_of(product.id)

    expect(plan.release_of(1).items).to eq pbi_list(pbi_b, pbi_c, pbi_a)
  end
end
