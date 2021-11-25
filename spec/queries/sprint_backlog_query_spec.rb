# typed: false
require 'rails_helper'

RSpec.describe SprintBacklogQuery do
  let!(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id, acceptance_criteria: %w(CRT_A), size: 3, release: 1) }
  let!(:pbi_b) { add_pbi(product.id, type: :task, acceptance_criteria: %w(CRT_B), size: 3, release: 1) }
  let!(:pbi_c) { add_pbi(product.id, acceptance_criteria: %w(CRT_C1 CRT_C2 CRT_C3), size: 3, release: 1) }
  let!(:sprint) { start_sprint(product.id) }

  before do
    assign_pbi_to_sprint(product.id, pbi_c.id)
    assign_pbi_to_sprint(product.id, pbi_a.id)
    assign_pbi_to_sprint(product.id, pbi_b.id)
  end

  it do
    items = described_class.call(sprint.id).items
    item_pbis = items.map(&:pbi)
    pbis = [pbi_c, pbi_a, pbi_b]

    aggregate_failures do
      expect(item_pbis.map(&:id)).to eq pbis.map(&:id).map(&:to_s)
      expect(item_pbis.map(&:type)).to eq pbis.map(&:type)
      expect(items.map(&:acceptance_activities)).to eq pbis.map { |i| i.type.acceptance_activities }
      expect(items.map(&:status)).to eq pbis.map { |i| Work::Work.create(i).status }
    end
  end

  it do
    sbl = described_class.call(sprint.id)
    item_pbi = sbl.items.first.pbi
    expect(item_pbi.criteria.map(&:content)).to eq %w(CRT_C1 CRT_C2 CRT_C3)
  end

  it do
    sbl = described_class.call(sprint.id)
    item = sbl.items.first
    expect(item.tasks).to be_empty
  end

  it do
    plan_task(pbi_c.id, %w(Task1 Task2 Task3))
    sbl = described_class.call(sprint.id)
    tasks = sbl.items.first.tasks

    aggregate_failures do
      expect(tasks.map(&:pbi_id).uniq).to eq [pbi_c.id.to_s]
      expect(tasks[0].number).to eq 1
      expect(tasks[0].content).to eq 'Task1'
      expect(tasks[1].number).to eq 2
      expect(tasks[1].content).to eq 'Task2'
      expect(tasks[2].number).to eq 3
      expect(tasks[2].content).to eq 'Task3'
    end
  end

  it do
    accept_work(pbi_c)
    accept_work(pbi_b)
    sbl = described_class.call(sprint.id)

    aggregate_failures do
      expect(sbl.items[0]).to be_accepted
      expect(sbl.items[1]).to_not be_accepted
      expect(sbl.items[2]).to be_accepted
    end
  end
end
