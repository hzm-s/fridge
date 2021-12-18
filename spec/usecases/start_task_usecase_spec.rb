# typed: false
require 'rails_helper'

RSpec.describe StartTaskUsecase do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, assign: true) }

  it do
    plan_task(pbi.id, %w(Task1))
    plan_task(pbi.id, %w(Task2))
    plan_task(pbi.id, %w(Task3))

    described_class.perform(pbi.id, 2)

    sbi = SbiRepository::AR.find_by_pbi_id(pbi.id)

    aggregate_failures do
      expect(sbi.tasks.of(1).status.to_s).to eq 'todo'
      expect(sbi.tasks.of(2).status.to_s).to eq 'wip'
      expect(sbi.tasks.of(3).status.to_s).to eq 'todo'
    end
  end
end
