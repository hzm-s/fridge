# typed: false
require 'rails_helper'

RSpec.describe TaskListQuery do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:other_pbi) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 5, release: 1, assign: true) }

  before do
    plan_task(other_pbi.id, %w(Task0))
  end

  it do
    plan_task(pbi.id, %w(Task1 Task2 Task3))

    tasks = described_class.call(pbi.id.to_s)

    aggregate_failures do
      expect(tasks.map(&:sbi_id).uniq).to eq [pbi.id.to_s]
      expect(tasks.map(&:status).map(&:to_s).uniq).to eq ['todo']
      expect(tasks.map(&:content)).to eq %w(Task1 Task2 Task3)
    end
  end
end
