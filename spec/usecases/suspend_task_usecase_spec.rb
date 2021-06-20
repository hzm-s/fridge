# typed: false
require 'rails_helper'

RSpec.describe SuspendTaskUsecase do
  let(:product) { create_product }
  let!(:issue) { plan_issue(product.id) }

  it do
    plan_task(issue.id, %w(Task))
    start_task(issue.id, 1)

    described_class.perform(issue.id, 1)

    work = WorkRepository::AR.find_by_issue_id(issue.id)

    expect(work.task_of(1).status.to_s).to eq 'wait'
  end
end
