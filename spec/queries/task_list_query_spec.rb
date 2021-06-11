# typed: false
require 'rails_helper'

RSpec.describe TaskListQuery do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }

  before do
    start_sprint(product.id)
    assign_issue_to_sprint(product.id, issue.id)
  end

  it do
    plan_task(issue.id, %w(Task1 Task2 Task3))

    tasks = described_class.call(issue.id.to_s)

    aggregate_failures do
      expect(tasks.map(&:issue_id).uniq).to eq [issue.id.to_s]
      expect(tasks.map(&:status).uniq).to eq ['ready']
      expect(tasks.map(&:content)).to eq %w(Task1 Task2 Task3)
    end
  end
end
