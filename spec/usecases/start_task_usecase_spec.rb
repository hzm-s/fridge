# typed: false
require 'rails_helper'

describe StartTaskUsecase do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, assign: true) }

  it do
    plan_task(pbi.id, %w(Task1))
    plan_task(pbi.id, %w(Task2))
    plan_task(pbi.id, %w(Task3))

    described_class.perform(pbi.id, 2)

    work = WorkRepository::AR.find_by_pbi_id(pbi.id)

    aggregate_failures do
      expect(work.tasks.of(1).status.to_s).to eq 'todo'
      expect(work.tasks.of(2).status.to_s).to eq 'wip'
      expect(work.tasks.of(3).status.to_s).to eq 'todo'
    end
  end
end
