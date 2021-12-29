# typed: false
require 'rails_helper'

describe DropTaskUsecase do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, assign: true) }

  it do
    plan_task(pbi.id, %w(Task1 Task2 Task3))

    described_class.perform(pbi.id, 2)

    sbi = SbiRepository::AR.find_by_pbi_id(pbi.id)

    aggregate_failures do
      expect(sbi.tasks.of(1).content.to_s).to eq 'Task1'
      expect(sbi.tasks.of(2)).to be_nil
      expect(sbi.tasks.of(3).content.to_s).to eq 'Task3'
    end
  end
end
