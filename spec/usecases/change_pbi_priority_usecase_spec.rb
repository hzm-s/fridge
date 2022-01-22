# typed: false
require 'rails_helper'

describe ChangePbiPriorityUsecase do
  let(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id).id }
  let!(:pbi_b) { add_pbi(product.id).id }
  let!(:pbi_c) { add_pbi(product.id).id }
  let(:roles) { team_roles(:po) }

  it do
    described_class.perform(product.id, roles, pbi_a, pbi_c)

    roadmap = roadmap_of(product.id)

    expect(roadmap.release_of(1).items).to eq pbi_list(pbi_b, pbi_c, pbi_a)
  end
end
