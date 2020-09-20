# typed: false
require 'rails_helper'

RSpec.describe AddReleaseItemUsecase do
  let(:product) { create_product }
  let(:release) { add_release(product.id) }
  let(:issue) { add_issue(product.id) }

  it do
    described_class.perform(issue.id, release)

    stored = ReleaseRepository::AR.find_by_id(release)

    expect(stored.items.to_a).to include issue.id
  end
end
