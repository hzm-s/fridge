# typed: false
require 'rails_helper'

RSpec.describe PlannedIssueQuery do
  let(:product) { create_product }
  let!(:issue_a) { Issue::Id.create }
  let!(:issue_b) { Issue::Id.create }
  let!(:issue_c) { Issue::Id.create }
  let!(:issue_d) { Issue::Id.create }
  let!(:issue_e) { Issue::Id.create }
  let!(:issue_z) { Issue::Id.create }
  let(:roles) { team_roles(:po) }

  before do
    @plan = plan_of(product.id)
    @plan.append_release
    @plan.append_release

    @plan.release_of(1).tap do |r|
      r.plan_issue(issue_a)
      r.plan_issue(issue_b)
      @plan.update_release(r)
    end

    @plan.release_of(2).tap do |r|
      r.plan_issue(issue_c)
      @plan.update_release(r)
    end

    @plan.release_of(3).tap do |r|
      r.plan_issue(issue_d)
      r.plan_issue(issue_e)
      @plan.update_release(r)
    end
  end

  it do
    query = described_class.new(@plan)

    aggregate_failures do
      expect(query.call(1, 0)).to eq issue_a
      expect(query.call(1, 1)).to eq issue_b
      expect(query.call(1, 2)).to be_nil
      expect(query.call(2, 0)).to eq issue_c
      expect(query.call(2, 2)).to be_nil
      expect(query.call(3, 0)).to eq issue_d
      expect(query.call(3, 1)).to eq issue_e
      expect(query.call(3, 2)).to be_nil
      expect(query.call(4, 0)).to be_nil
    end
  end
end
