# typed: false
require 'rails_helper'

RSpec.describe StartTaskUsecase do
  let(:product) { create_product }
  let!(:issue) { plan_issue(product.id, assign: true) }

  it do
    plan_task(issue.id, %w(Task))

    described_class.perform(issue.id, 1)

    work = WorkRepository::AR.find_by_issue_id(issue.id)

    expect(work.tasks.of(1).status.to_s).to eq 'wip'
  end
end
