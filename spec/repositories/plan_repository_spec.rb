# typed: false
require 'rails_helper'

RSpec.describe PlanRepository::AR do
  describe 'Store' do
    it do
      product = nil
      expect { product = create_product }
        .to change { Dao::Plan.count }.by(1)

      issue_a = add_issue(product.id)
      issue_b = add_issue(product.id)
      issue_c = add_issue(product.id)

      plan = described_class.find_by_product_id(product.id)
      releases = plan.scoped
      releases = releases.add(Plan::Release.new('Ph1', issue_list(issue_a.id)))
      releases = releases.add(Plan::Release.new('Ph2', issue_list(issue_b.id)))
      plan.update_scoped(releases)

      expect { described_class.store(plan) }
        .to change { Dao::Plan.count }.by(0)
        .and change { Dao::Release.count }.by(2)

      rel = Dao::Plan.find_by(dao_product_id: plan.product_id.to_s)
      expect(rel.not_scoped_issues).to eq [issue_c.id.to_s]
      expect(rel.releases.size).to eq 2
      expect(rel.releases[0].release_id).to eq 'Ph1'
      expect(rel.releases[0].tail).to eq issue_a.id.to_s
      expect(rel.releases[1].release_id).to eq 'Ph2'
      expect(rel.releases[1].tail).to eq issue_b.id.to_s
    end
  end

  xdescribe 'Find' do
    let(:product) { create_product }

    let(:issue_a) { add_issue(product.id) }
    let(:issue_b) { add_issue(product.id) }
    let(:issue_c) { add_issue(product.id) }

    it do
      plan = Plan::Plan.create(product.id)
      plan.append_issue(issue_a.id)
      plan.append_issue(issue_b.id)
      plan.append_issue(issue_c.id)
      plan.specify_release('Ph1', issue_a.id)
      plan.specify_release('Ph2', issue_c.id)

      described_class.store(plan)
      stored = described_class.find_by_product_id(product.id)

      expect(stored.order).to eq Plan::Order.new([issue_a.id, issue_b.id, issue_c.id])
      expect(stored.scopes).to eq Plan::ScopeSet.new([
        Plan::Scope.new('Ph1', issue_a.id),
        Plan::Scope.new('Ph2', issue_c.id)
      ])
    end
  end
end
