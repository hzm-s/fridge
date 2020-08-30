# typed: false
require 'rails_helper'

RSpec.describe RemoveReleaseUsecase do
  let(:product) { create_product }

  it do
    release = add_release(product.id)

    described_class.perform(product.id, 2)

    plan = PlanRepository::AR.find_by_product_id(product.id)

    expect { plan.release(2) }.to raise_error(Plan::ReleaseNotFound)
  end

  it do
    release = add_release(product.id)

    add_pbi(product.id, release: 2)

    expect { described_class.perform(product.id, 2) }
      .to raise_error(Plan::CanNotRemoveRelease)
  end
end
