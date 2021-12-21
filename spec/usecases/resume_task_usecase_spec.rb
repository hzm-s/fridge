# typed: false
require 'rails_helper'

RSpec.describe ResumeTaskUsecase do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, assign: true) }

  it do
    plan_task(pbi.id, %w(Task))
    start_task(pbi.id, 1)
    suspend_task(pbi.id, 1)

    described_class.perform(pbi.id, 1)

    sbi = SbiRepository::AR.find_by_pbi_id(pbi.id)

    expect(sbi.tasks.of(1).status.to_s).to eq 'wip'
  end
end
