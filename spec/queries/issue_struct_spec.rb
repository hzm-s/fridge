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

  it 'returns requirement to have acceptance criteria' do
    s = build_struct { plan_issue(product.id, type: :task) }
    expect(s).to_not be_must_have_acceptance_criteria
  end

  it 'returns status' do
    issue = plan_issue(product.id)
    s = build_struct { issue }
    expect(s.status).to eq issue.status
  end

  it 'returns criteria satisfaction' do
    issue = plan_issue(product.id, acceptance_criteria: %w(AC1 AC2))
    satisfy_acceptance_criteria(issue.id, [1])

    s = build_struct { issue }

    expect(s).to_not be_can_accept
  end

  it 'returns accept issue activity' do
    feature = build_struct { plan_issue(product.id, type: :feature) }
    task = build_struct { plan_issue(product.id, type: :task) }

    aggregate_failures do
      expect(feature.accept_issue_activity).to eq :accept_feature
      expect(task.accept_issue_activity).to eq :accept_task
    end
  end

  private

  def build_struct
    yield.then { |i| described_class.new(Dao::Issue.find(i.id)) }
  end
end
