# typed: false
require 'rails_helper'

RSpec.describe PlannedIssueResolver do
  let(:product) { create_product }
  let!(:issue_a) { Issue::Id.create }
  let!(:issue_b) { Issue::Id.create }
  let!(:issue_c) { Issue::Id.create }
  let!(:issue_d) { Issue::Id.create }
  let!(:issue_e) { Issue::Id.create }
  let!(:issue_z) { Issue::Id.create }
  let(:roles) { team_roles(:po) }

  before do
    @plan = PlanRepository::AR.find_by_product_id(product.id)
    @plan.append_release
    @plan.append_release

    @plan.release_of(1).tap do |r|
      r.append_issue(issue_a)
      r.append_issue(issue_b)
      @plan.update_release(r)
    end

    @plan.release_of(2).tap do |r|
      r.append_issue(issue_c)
      @plan.update_release(r)
    end

    @plan.release_of(3).tap do |r|
      r.append_issue(issue_d)
      r.append_issue(issue_e)
      @plan.update_release(r)
    end
  end

  describe '#resolve_release' do
    it do
      resolver = described_class.new(@plan)

      aggregate_failures do
        expect(resolver.resolve_release(issue_a).number).to eq 1
        expect(resolver.resolve_release(issue_b).number).to eq 1
        expect(resolver.resolve_release(issue_c).number).to eq 2
        expect(resolver.resolve_release(issue_d).number).to eq 3
        expect(resolver.resolve_release(issue_e).number).to eq 3
        expect(resolver.resolve_release(issue_z)).to be_nil
      end
    end
  end

  describe '#resolve_issue' do
    xit do
      resolver = described_class.new(@plan)

      aggregate_failures do
        expect(resolver.resolve_issue(1, 0)).to eq issue_a
        expect(resolver.resolve_issue(1, 1)).to eq issue_b
        expect(resolver.resolve_issue(1, 2)).to be_nil
        expect(resolver.resolve_issue(2, 0)).to eq issue_c
        expect(resolver.resolve_issue(2, 2)).to be_nil
        expect(resolver.resolve_issue(3, 0)).to eq issue_d
        expect(resolver.resolve_issue(3, 1)).to eq issue_e
        expect(resolver.resolve_issue(3, 2)).to be_nil
        expect(resolver.resolve_issue(4, 0)).to be_nil
      end
    end
  end
end
