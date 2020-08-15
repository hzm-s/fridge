# typed: false
require 'rails_helper'

RSpec.describe RemoveReleaseUsecase do
  let(:product) { create_product }

  before do
    add_pbi(product.id)
    @release = add_release(product.id)
  end

  it do
    described_class.perform(@release.id)

    expect { ReleaseRepository::AR.find_by_id(@release.id) }
      .to raise_error(ActiveRecord::RecordNotFound)
  end
end
