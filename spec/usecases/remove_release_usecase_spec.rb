# typed: false
require 'rails_helper'

describe RemoveReleaseUsecase do
  let(:product) { create_product }
  let(:roles) { team_roles(:po) }

  before do
    append_release(product.id)
    add_pbi(product.id, release: 1)
  end

  it do
    described_class.perform(product.id, roles, 2)

    roadmap = roadmap_of(product.id)

    expect(roadmap.releases.map(&:number)).to match_array [1]
  end

  it do
    expect { described_class.perform(product.id, roles, 1) }
      .to raise_error(Roadmap::ReleaseIsNotEmpty)
  end
end
