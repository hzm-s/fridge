# typed: false
require 'rails_helper'

RSpec.describe SprintBacklogQuery do
  let!(:product) { create_product }
  let!(:issue_a) { plan_issue(product.id, acceptance_criteria: %w(CRT_A), size: 3, release: 1) }
  let!(:issue_b) { plan_issue(product.id, type: :task, acceptance_criteria: %w(CRT_B), size: 3, release: 1) }
  let!(:issue_c) { plan_issue(product.id, acceptance_criteria: %w(CRT_C1 CRT_C2 CRT_C3), size: 3, release: 1) }
  let!(:sprint) { start_sprint(product.id) }

  before do
    assign_issue_to_sprint(product.id, issue_c.id)
    assign_issue_to_sprint(product.id, issue_a.id)
    assign_issue_to_sprint(product.id, issue_b.id)
  end

  it do
    sbl = described_class.call(sprint.id)

    aggregate_failures do
      expect(sbl.issues.map(&:id)).to eq [issue_c, issue_a, issue_b].map(&:id).map(&:to_s)
      expect(sbl.issues.map(&:type)).to eq [issue_c, issue_a, issue_b].map(&:type)

      expect(sbl.issues[0].acceptance_activity_name).to eq :accept_feature
      expect(sbl.issues[0].acceptance).to eq Work::Work.create(issue_c).acceptance
      expect(sbl.issues[1].acceptance_activity_name).to eq :accept_feature
      expect(sbl.issues[1].acceptance).to eq Work::Work.create(issue_a).acceptance
      expect(sbl.issues[2].acceptance_activity_name).to eq :accept_task
      expect(sbl.issues[2].acceptance).to eq Work::Work.create(issue_b).acceptance
    end
  end

  it do
    sbl = described_class.call(sprint.id)
    issue = sbl.issues.first
    expect(issue.criteria.map(&:content)).to eq %w(CRT_C1 CRT_C2 CRT_C3)
  end

  it do
    sbl = described_class.call(sprint.id)
    issue = sbl.issues.first
    expect(issue.tasks).to be_empty
  end

  it do
    plan_task(issue_c.id, %w(Task1 Task2 Task3))
    sbl = described_class.call(sprint.id)
    issue = sbl.issues.first

    aggregate_failures do
      expect(issue.tasks.map(&:issue_id).uniq).to eq [issue_c.id.to_s]
      expect(issue.tasks[0].number).to eq 1
      expect(issue.tasks[0].content).to eq 'Task1'
      expect(issue.tasks[1].number).to eq 2
      expect(issue.tasks[1].content).to eq 'Task2'
      expect(issue.tasks[2].number).to eq 3
      expect(issue.tasks[2].content).to eq 'Task3'
    end
  end

  xit do
    accept_issue(issue_c)
    accept_issue(issue_b)
    sbl = described_class.call(sprint.id)

    aggregate_failures do
      expect(sbl.issues[0]).to be_accepted
      expect(sbl.issues[1]).to_not be_accepted
      expect(sbl.issues[2]).to be_accepted
    end
  end
end
