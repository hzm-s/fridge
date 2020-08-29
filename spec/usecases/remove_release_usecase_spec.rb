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

  xit do
    release = add_release(product.id)

    add_pbi(product.id, release: release.id)

    expect { described_class.perform(release.id) }
      .to raise_error(Release::CanNotRemoveRelease)
  end
end
