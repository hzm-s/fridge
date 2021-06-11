# typed: false
require 'rails_helper'

RSpec.describe PlanTaskUsecase do
  let(:product) { create_product }
  let!(:issue) { plan_issue(product.id) }

  it do
    described_class.perform(issue.id, 'Task1')
    described_class.perform(issue.id, 'Task2')
    described_class.perform(issue.id, 'Task3')

    work = WorkRepository::AR.find_by_issue_id(issue.id)

    aggregate_failures do
      expect(work.task_of(1).content).to eq 'Task1'
      expect(work.task_of(2).content).to eq 'Task2'
      expect(work.task_of(3).content).to eq 'Task3'
      expect(work.tasks.map(&:status).uniq).to eq [Work::TaskStatus::Todo]
    end
  end
end
