# typed: false
require 'rails_helper'

RSpec.describe IssueStruct do
  let!(:product) { create_product }

  it 'returns acceptance criteria' do
    issue = plan_issue(product.id, acceptance_criteria: %w(AC1 AC2 AC3))

    s = described_class.new(Dao::Issue.last)

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
    issue = plan_issue(product.id, type: Issue::Types::Task)

    s = described_class.new(Dao::Issue.last)

    expect(s).to_not be_must_have_acceptance_criteria
  end

  it 'returns status' do
    issue = plan_issue(product.id)

    s = described_class.new(Dao::Issue.last)

    expect(s.status).to eq issue.status
  end

  it 'returns accept issue activity' do
    feature =
      plan_issue(product.id, type: :feature)
      .then { |i| described_class.new(Dao::Issue.find(i.id)) }

    task =
      plan_issue(product.id, type: :task)
      .then { |i| described_class.new(Dao::Issue.find(i.id)) }

    aggregate_failures do
      expect(feature.accept_issue_activity).to eq :accept_feature
      expect(task.accept_issue_activity).to eq :accept_task
    end
  end
end
