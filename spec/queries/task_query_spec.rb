# typed: false
require 'rails_helper'

RSpec.describe TaskQuery do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }

  before do
    start_sprint(product.id)
    assign_issue_to_sprint(product.id, issue.id)
  end

  it do
    plan_task(issue.id, %w(Task1 Task2 Task3))

    task = described_class.call(issue.id.to_s, 3)

    aggregate_failures do
      expect(task.issue_id).to eq issue.id.to_s
      expect(task.number).to eq 3
      expect(task.status).to eq 'ready'
      expect(task.content).to eq 'Task3'
    end
  end
end
