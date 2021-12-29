# typed: false
require 'rails_helper'

describe DropPbiUsecase do
  let(:product) { create_product }
  let(:roles) { team_roles(:po) }

  it do
    pbi_a = add_pbi(product.id).id
    pbi_b = add_pbi(product.id).id
    pbi_c = add_pbi(product.id).id

    described_class.perform(product.id, roles, pbi_b)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    aggregate_failures do
      expect { PbiRepository::AR.find_by_id(pbi_b) }.to raise_error Pbi::NotFound
      expect(plan.recent_release.items).to eq pbi_list(pbi_a, pbi_c)
    end
  end
end
