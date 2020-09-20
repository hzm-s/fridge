# typed: false
require 'rails_helper'

RSpec.describe RemoveReleaseUsecase do
  let(:product) { create_product }

  it do
    release = add_release(product.id)

    described_class.perform(release.id)

    expect(Dao::Release.find_by(id: release.id.to_s)).to be_nil
  end
end
