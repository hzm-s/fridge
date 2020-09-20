# typed: false
require 'rails_helper'

RSpec.describe ManageReleaseItemUsecase do
  let!(:product) { create_product }
  let!(:release1) { add_release(product.id).id }
  let!(:release2) { add_release(product.id).id }
  let!(:item_a) { add_issue(product.id).id }
  let!(:item_b) { add_issue(product.id).id }
  let!(:item_c) { add_issue(product.id).id }
  let!(:item_d) { add_issue(product.id).id }
  let!(:item_e) { add_issue(product.id).id }

  context 'Add' do
    it do
      described_class.perform(item_a, nil, release1, 0)
      expect(fetch_release(release1).items.to_a).to include item_a
    end

    it do
      add_issue_to_release(item_a, release1)
      add_issue_to_release(item_b, release1)
      add_issue_to_release(item_c, release1)

      described_class.perform(item_d, nil, release1, 1)
      expect(fetch_release(release1).items.to_a).to eq [item_a, item_d, item_b, item_c]
    end
  end

  context 'Remove' do
    before do
      add_issue_to_release(item_a, release1)
      add_issue_to_release(item_b, release1)
      add_issue_to_release(item_c, release1)
    end

    it do
      described_class.perform(item_b, release1, nil, 999)
      expect(fetch_release(release1).items.to_a).to eq [item_a, item_c]
    end
  end

  context 'Swap priorities' do
    before do
      add_issue_to_release(item_a, release1)
      add_issue_to_release(item_b, release1)
      add_issue_to_release(item_c, release1)
    end

    it do
      described_class.perform(item_c, release1, release1, 1)
      expect(fetch_release(release1).items.to_a).to eq [item_a, item_c, item_b]
    end
  end

  context 'Change release' do
    before do
      add_issue_to_release(item_a, release1)
      add_issue_to_release(item_b, release1)
      add_issue_to_release(item_c, release1)
      add_issue_to_release(item_d, release2)
      add_issue_to_release(item_e, release2)
    end

    it do
      described_class.perform(item_b, release1, release2, 0)
      expect(fetch_release(release1).items.to_a).to eq [item_a, item_c]
      expect(fetch_release(release2).items.to_a).to eq [item_b, item_d, item_e]
    end

    it do
      described_class.perform(item_e, release2, release1, 3)
      expect(fetch_release(release1).items.to_a).to eq [item_a, item_b, item_c, item_e]
      expect(fetch_release(release2).items.to_a).to eq [item_d]
    end
  end

  private

  def fetch_release(id)
    ReleaseRepository::AR.find_by_id(id)
  end
end
