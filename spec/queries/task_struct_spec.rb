# typed: false
require 'rails_helper'

RSpec.describe TaskStruct do
  let!(:product) { create_product }
  let!(:issue) { plan_issue(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let(:dao_task) { Dao::Task.last }

  before do
    plan_task(issue.id, %w(Task1))
  end

  it do
    task = described_class.new(issue.id.to_s, dao_task)

    aggregate_failures do
      expect(task.issue_id).to eq issue.id.to_s
      expect(task.number).to eq 1
      expect(task.content).to eq 'Task1'
      expect(task.status).to eq Work::TaskStatus.from_string('todo')
      expect(task.available_activities).to match_array(['start_task', 'update_task'])
    end
  end
end
