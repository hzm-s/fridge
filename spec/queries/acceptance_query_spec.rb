# typed: false
require 'rails_helper'

xdescribe AcceptanceQuery do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT_A CRT_B CRT_C), size: 3, release: 1, assign: true) }
  let(:work) { WorkRepository::AR.find_by_issue_id(issue.id) }

  it do
    a = described_class.call(issue.id)

    aggregate_failures do
      expect(a.issue_id).to eq issue.id.to_s
      expect(a.issue_description).to eq issue.description.to_s
      expect(a.activities).to eq issue.type.acceptance_activities
      expect(a.work_status).to eq work.status
    end
  end

  it do
    satisfy_acceptance_criteria(issue.id, [2])    
    a = described_class.call(issue.id)

    aggregate_failures do
      expect(a.criteria[0].number).to eq 1
      expect(a.criteria[0].content).to eq 'CRT_A'
      expect(a.criteria[0]).to_not be_satisfied
      expect(a.criteria[1].number).to eq 2
      expect(a.criteria[1].content).to eq 'CRT_B'
      expect(a.criteria[1]).to be_satisfied
      expect(a.criteria[2].number).to eq 3
      expect(a.criteria[2].content).to eq 'CRT_C'
      expect(a.criteria[2]).to_not be_satisfied
      expect(a).to_not be_can_accept
    end
  end
end
