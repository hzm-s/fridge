# typed: false
require 'rails_helper'

describe ProductBacklogQuery do
  let!(:product) { create_product }

  let!(:issue_a) { add_issue(product.id).id }
  let!(:issue_b) { add_issue(product.id).id }
  let!(:issue_c) { add_issue(product.id).id }
  let!(:issue_d) { add_issue(product.id).id }
  let!(:issue_e) { add_issue(product.id).id }
  let!(:issue_f) { add_issue(product.id).id }
  let!(:issue_g) { add_issue(product.id).id }

  it do
    SwapOrderedIssuesUsecase.perform(product.id, issue_d, 1)

    pbl = described_class.call(product.id.to_s)

    aggregate_failures do
      expect(pbl.scoped).to be_empty
      expect(pbl.unscoped.map(&:id)).to eq [issue_a, issue_d, issue_b, issue_c, issue_e, issue_f, issue_g].map(&:to_s)
    end
  end

  it do
    SpecifyReleaseUsecase.perform(product.id, 'Ph1', issue_c)
    SpecifyReleaseUsecase.perform(product.id, 'Ph2', issue_e)
    SpecifyReleaseUsecase.perform(product.id, 'Ph3', issue_f)

    pbl = described_class.call(product.id.to_s)

    aggregate_failures do
      expect(pbl.scoped.size).to eq 3
      expect(pbl.scoped[0].release_id).to eq 'Ph1'
      expect(pbl.scoped[0].items.map(&:id)).to eq [issue_a, issue_b, issue_c].map(&:to_s)
      expect(pbl.scoped[1].release_id).to eq 'Ph2'
      expect(pbl.scoped[1].items.map(&:id)).to eq [issue_d, issue_e].map(&:to_s)
      expect(pbl.scoped[2].release_id).to eq 'Ph3'
      expect(pbl.scoped[2].items.map(&:id)).to eq [issue_f].map(&:to_s)
      expect(pbl.unscoped.map(&:id)).to eq [issue_g].map(&:to_s)
    end
  end
end
