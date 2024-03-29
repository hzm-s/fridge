# typed: false
require 'rails_helper'

describe PlanTaskUsecase do
  let(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, assign: true) }

  it do
    described_class.perform(pbi.id, s_sentence('Task1'))
    described_class.perform(pbi.id, s_sentence('Task2'))
    described_class.perform(pbi.id, s_sentence('Task3'))

    work = WorkRepository::AR.find_by_pbi_id(pbi.id)

    aggregate_failures do
      expect(work.tasks.of(1).content.to_s).to eq 'Task1'
      expect(work.tasks.of(2).content.to_s).to eq 'Task2'
      expect(work.tasks.of(3).content.to_s).to eq 'Task3'
      expect(work.tasks.to_a.map(&:status).uniq).to eq [Work::TaskStatus.from_string('todo')]
    end
  end
end
