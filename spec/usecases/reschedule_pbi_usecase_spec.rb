# typed: false
require 'rails_helper'

describe ReschedulePbiUsecase do
  let(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id, release: 1).id }
  let!(:pbi_b) { add_pbi(product.id, release: 1).id }
  let!(:pbi_c) { add_pbi(product.id, release: 2).id }
  let(:roles) { team_roles(:po) }

  it do
    described_class.perform(product.id, roles, pbi_c, 1, pbi_b)

    roadmap = roadmap_of(product.id)
    expect(roadmap.release_of(1).items).to eq pbi_list(pbi_a, pbi_c, pbi_b)
  end
end
