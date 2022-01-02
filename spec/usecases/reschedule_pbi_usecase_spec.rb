# typed: false
require 'rails_helper'

describe ReschedulePbiUsecase do
  let(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id, release: 1).id }
  let!(:pbi_b) { add_pbi(product.id, release: 1).id }
  let!(:pbi_c) { add_pbi(product.id, release: 2).id }
  let!(:pbi_d) { add_pbi(product.id, release: 2).id }
  let!(:pbi_e) { add_pbi(product.id, release: 2).id }
  let(:roles) { team_roles(:po) }

  before do
    append_release(product.id)
  end

  it do
    described_class.perform(product.id, roles, pbi_c, 1, pbi_b)

    plan = plan_of(product.id)
    aggregate_failures do
      expect(plan.release_of(1).items).to eq pbi_list(pbi_a, pbi_c, pbi_b)
      expect(plan.release_of(2).items).to eq pbi_list(pbi_d, pbi_e)
      expect(plan.release_of(3).items).to eq pbi_list
    end
  end

  it do
    described_class.perform(product.id, roles, pbi_d, 3, nil)

    plan = plan_of(product.id)
    aggregate_failures do
      expect(plan.release_of(1).items).to eq pbi_list(pbi_a, pbi_b)
      expect(plan.release_of(2).items).to eq pbi_list(pbi_c, pbi_e)
      expect(plan.release_of(3).items).to eq pbi_list(pbi_d)
    end
  end

  it do
    described_class.perform(product.id, roles, pbi_c, 1, nil)

    plan = plan_of(product.id)
    aggregate_failures do
      expect(plan.release_of(1).items).to eq pbi_list(pbi_a, pbi_b, pbi_c)
      expect(plan.release_of(2).items).to eq pbi_list(pbi_d, pbi_e)
      expect(plan.release_of(3).items).to eq pbi_list
    end
  end
end
