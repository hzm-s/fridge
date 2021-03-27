# typed: false
require 'rails_helper'

describe ProductBacklogQuery do
  let!(:product) { create_product }
  let!(:issue_a) { plan_issue(product.id, release: 1).id }
  let!(:issue_b) { plan_issue(product.id, release: 1).id }
  let!(:issue_c) { plan_issue(product.id, release: 2).id }
  let!(:issue_d) { plan_issue(product.id, release: 2).id }
  let!(:issue_e) { plan_issue(product.id, release: 2).id }
  let(:roles) { team_roles(:po) }

  before do
    update_plan(product.id) { |p| p.append_release }
    update_release(product.id, 2) do |r|
      r.modify_description('2nd')
    end
  end

  it do
    pbl = described_class.call(product.id.to_s)

    aggregate_failures do
      expect(pbl.releases[0].number).to eq 1
      expect(pbl.releases[0].description).to be_nil
      expect(pbl.releases[0].issues.map(&:id)).to eq [issue_a, issue_b].map(&:to_s)
      expect(pbl.releases[0]).to_not be_can_remove
      expect(pbl.releases[1].number).to eq 2
      expect(pbl.releases[1].description).to eq '2nd'
      expect(pbl.releases[1].issues.map(&:id)).to eq [issue_c, issue_d, issue_e].map(&:to_s)
      expect(pbl.releases[1]).to_not be_can_remove
      expect(pbl.releases[2].number).to eq 3
      expect(pbl.releases[0].description).to be_nil
      expect(pbl.releases[2].issues).to be_empty
      expect(pbl.releases[2]).to be_can_remove
    end
  end
end
