# typed: false
require 'rails_helper'

RSpec.describe RemoveReleaseItemUsecase do
  let(:product) { create_product }
  let(:release) { add_release(product.id) }
  let(:issue) { add_issue(product.id, release: release.id) }

  it do
    described_class.perform(issue.id, release.id)

    stored = ReleaseRepository::AR.find_by_id(release.id)

    expect(stored.items).to be_empty
  end
end
