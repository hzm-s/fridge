# typed: false
require 'rails_helper'

RSpec.describe TaskQuery do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }

  it do
    plan_task(pbi.id, %w(Task1 Task2 Task3))

    task = described_class.call(pbi.id.to_s, 3)

    aggregate_failures do
      expect(task.pbi_id).to eq pbi.id.to_s
      expect(task.number).to eq 3
      expect(task.content).to eq 'Task3'
    end
  end
end
