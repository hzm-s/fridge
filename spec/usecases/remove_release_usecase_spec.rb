# typed: false
require 'rails_helper'

RSpec.describe RemoveReleaseUsecase do
  let(:product) { create_product }
  let(:roles) { team_roles(:po) }

  before do
    append_release(product.id)
    add_pbi(product.id, release: 1)
  end

  it do
    described_class.perform(product.id, roles, 2)

    plan = plan_of(product.id)

    expect(plan.releases.map(&:number)).to match_array [1]
  end

  it do
    expect { described_class.perform(product.id, roles, 1) }
      .to raise_error(Plan::ReleaseIsNotEmpty)
  end
end
