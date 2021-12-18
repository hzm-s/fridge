# typed: false
require 'rails_helper'

RSpec.describe TaskStruct do
  let!(:product) { create_product }
  let!(:pbi) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let(:dao_task) { Dao::Task.last }

  before do
    plan_task(pbi.id, %w(Task1))
  end

  it do
    task = described_class.new(pbi.id.to_s, dao_task)

    aggregate_failures do
      expect(task.pbi_id).to eq pbi.id.to_s
      expect(task.number).to eq 1
      expect(task.content).to eq 'Task1'
      expect(task.status).to eq Work::TaskStatus.from_string('todo')
    end
  end
end
