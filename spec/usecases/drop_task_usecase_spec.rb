# typed: false
require 'rails_helper'

RSpec.describe DropTaskUsecase do
  let(:product) { create_product }
  let!(:issue) { plan_issue(product.id) }

  it do
    plan_task(issue.id, %w(Task1 Task2 Task3))

    described_class.perform(issue.id, 2)

    work = WorkRepository::AR.find_by_issue_id(issue.id)

    aggregate_failures do
      expect(work.task_of(1).content.to_s).to eq 'Task1'
      expect(work.task_of(2)).to be_nil
      expect(work.task_of(3).content.to_s).to eq 'Task3'
    end
  end
end
