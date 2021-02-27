# typed: false
require 'rails_helper'

RSpec.describe PlanRepository::AR do
  let(:roles) { team_roles(:po) }

  describe 'Store' do
    it do
      product = create_product

      issue_a = add_issue(product.id)
      issue_b = add_issue(product.id)
      issue_c = add_issue(product.id)

      plan = described_class.find_by_product_id(product.id)

      scheduled = release_list({
        'Ph1' => issue_list(issue_a.id, issue_c.id),
        'Ph2' => issue_list(issue_b.id)
      })
      plan.update_scheduled(roles, scheduled)

      expect { described_class.store(plan) }
        .to change { Dao::Plan.count }.by(0)
        .and change { Dao::Release.count }.by(2)

      rel = Dao::Plan.find_by(dao_product_id: plan.product_id.to_s)
      expect(rel.releases.size).to eq 2
      expect(rel.releases[0].name).to eq 'Ph1'
      expect(rel.releases[0].issues).to eq [issue_a.id.to_s, issue_c.id.to_s]
      expect(rel.releases[1].name).to eq 'Ph2'
      expect(rel.releases[1].issues).to eq [issue_b.id.to_s]
    end
  end

  describe 'Find' do
    let(:product) { create_product }

    let(:issue_a) { add_issue(product.id) }
    let(:issue_b) { add_issue(product.id) }
    let(:issue_c) { add_issue(product.id) }

    it do
      stored = described_class.find_by_product_id(product.id)

      scheduled = release_list({
        'Ph1' => issue_list(issue_a.id),
        'Ph2' => issue_list(issue_b.id, issue_c.id)
      })
      stored.update_scheduled(roles, scheduled)

      expect(stored.scheduled).to eq scheduled
    end
  end
end
