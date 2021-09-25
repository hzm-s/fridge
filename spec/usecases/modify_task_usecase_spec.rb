# typed: false
require 'rails_helper'

RSpec.describe ModifyTaskUsecase do
  let(:product) { create_product }
  let!(:issue) { plan_issue(product.id) }

  it do
    plan_task(issue.id, %w(Task1 Task2 Task3))

    described_class.perform(issue.id, 2, s_sentence('Task02'))

    work = WorkRepository::AR.find_by_issue_id(issue.id)

    aggregate_failures do
      expect(work.tasks.of(1).content.to_s).to eq 'Task1'
      expect(work.tasks.of(2).content.to_s).to eq 'Task02'
      expect(work.tasks.of(3).content.to_s).to eq 'Task3'
    end
  end
end
