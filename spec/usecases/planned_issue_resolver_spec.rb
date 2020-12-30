# typed: false
require 'rails_helper'

RSpec.describe PlannedIssueResolver do
  let(:product) { create_product }
  let!(:issue_a) { add_issue(product.id).id }
  let!(:issue_b) { add_issue(product.id).id }
  let!(:issue_c) { add_issue(product.id).id }
  let!(:issue_d) { add_issue(product.id).id }
  let!(:issue_e) { add_issue(product.id).id }

  before do
    @plan = PlanRepository::AR.find_by_product_id(product.id)
    @plan.update_pending(issue_list(issue_a, issue_b))
    @plan.update_scheduled(
      release_list({
        'R1' => issue_list(issue_c, issue_d),
        'R2' => issue_list(issue_e),
      })
    )
    PlanRepository::AR.store(@plan)
  end

  describe '#resolve_pending' do
    it do
      resolver = described_class.new(@plan)
      aggregate_failures do
        expect(resolver.resolve_pending(0)).to eq issue_a
        expect(resolver.resolve_pending(1)).to eq issue_b
        expect(resolver.resolve_pending(2)).to be_nil
      end
    end
  end

  describe '#resolve_scheduled' do
    it do
      resolver = described_class.new(@plan)
      aggregate_failures do
        expect(resolver.resolve_scheduled('R1', 0)).to eq issue_c
        expect(resolver.resolve_scheduled('R1', 1)).to eq issue_d
        expect(resolver.resolve_scheduled('R1', 2)).to be_nil
        expect(resolver.resolve_scheduled('R2', 0)).to eq issue_e
        expect(resolver.resolve_scheduled('R2', 1)).to be_nil
      end
    end
  end
end
