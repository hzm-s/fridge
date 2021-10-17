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
    items = described_class.call(sprint.id).items
    item_issues = items.map(&:issue)
    issues = [issue_c, issue_a, issue_b]

    aggregate_failures do
      expect(item_issues.map(&:id)).to eq issues.map(&:id).map(&:to_s)
      expect(item_issues.map(&:type)).to eq issues.map(&:type)
      expect(items.map(&:acceptance_activities)).to eq issues.map { |i| i.type.acceptance_activities }
      expect(items.map(&:status)).to eq issues.map { |i| Work::Work.create(i).status }
    end
  end

  it do
    sbl = described_class.call(sprint.id)
    item_issue = sbl.items.first.issue
    expect(item_issue.criteria.map(&:content)).to eq %w(CRT_C1 CRT_C2 CRT_C3)
  end

  it do
    sbl = described_class.call(sprint.id)
    item = sbl.items.first
    expect(item.tasks).to be_empty
  end

  it do
    plan_task(issue_c.id, %w(Task1 Task2 Task3))
    sbl = described_class.call(sprint.id)
    tasks = sbl.items.first.tasks

    aggregate_failures do
      expect(tasks.map(&:issue_id).uniq).to eq [issue_c.id.to_s]
      expect(tasks[0].number).to eq 1
      expect(tasks[0].content).to eq 'Task1'
      expect(tasks[1].number).to eq 2
      expect(tasks[1].content).to eq 'Task2'
      expect(tasks[2].number).to eq 3
      expect(tasks[2].content).to eq 'Task3'
    end
  end

  it do
    accept_work(issue_c)
    accept_work(issue_b)
    sbl = described_class.call(sprint.id)

    aggregate_failures do
      expect(sbl.items[0]).to be_accepted
      expect(sbl.items[1]).to_not be_accepted
      expect(sbl.items[2]).to be_accepted
    end
  end
end
