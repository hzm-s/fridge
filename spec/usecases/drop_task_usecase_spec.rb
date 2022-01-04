# typed: false
require 'rails_helper'

describe DropTaskUsecase do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, assign: true) }

  it do
    plan_task(pbi.id, %w(Task1 Task2 Task3))

    described_class.perform(pbi.id, 2)

    work = WorkRepository::AR.find_by_pbi_id(pbi.id)

    aggregate_failures do
      expect(work.tasks.of(1).content.to_s).to eq 'Task1'
      expect(work.tasks.of(2)).to be_nil
      expect(work.tasks.of(3).content.to_s).to eq 'Task3'
    end
  end
end
