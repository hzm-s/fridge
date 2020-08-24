# typed: false
require 'rails_helper'

RSpec.describe RemoveReleaseUsecase do
  let(:product) { create_product }

  it do
    release = add_release(product.id)

    described_class.perform(release.id)

    expect { ReleaseRepository::AR.find_by_id(release.id) }
      .to raise_error(ActiveRecord::RecordNotFound)
  end

  xit do
    release = add_release(product.id)

    add_feature(product.id, release: release.id)

    expect { described_class.perform(release.id) }
      .to raise_error(Release::CanNotRemoveRelease)
  end
end
