# typed: false
require 'rails_helper'

describe CompleteTaskUsecase do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, assign: true) }

  it do
    plan_task(pbi.id, %w(Task))
    start_task(pbi.id, 1)

    described_class.perform(pbi.id, 1)

    work = WorkRepository::AR.find_by_pbi_id(pbi.id)

    expect(work.tasks.of(1).status.to_s).to eq 'done'
  end
end
