# typed: false
require 'rails_helper'

RSpec.describe IssueStruct do
  let!(:product) { create_product }

  it 'returns acceptance criteria' do
    issue = plan_issue(product.id, acceptance_criteria: %w(AC1 AC2 AC3))
    s = build_struct { issue }

    aggregate_failures do
      expect(s.criteria.map(&:issue_id).uniq).to eq [issue.id.to_s]
      expect(s.criteria[0].number).to eq 1
      expect(s.criteria[0].content).to eq 'AC1'
      expect(s.criteria[1].number).to eq 2
      expect(s.criteria[1].content).to eq 'AC2'
      expect(s.criteria[2].number).to eq 3
      expect(s.criteria[2].content).to eq 'AC3'
    end
  end

  it 'returns status' do
    issue = plan_issue(product.id)
    s = build_struct { issue }
    expect(s.status).to eq issue.status
  end

  private

  def build_struct
    yield.then { |i| described_class.new(Dao::Issue.find(i.id)) }
  end
end
