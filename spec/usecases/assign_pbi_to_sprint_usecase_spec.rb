# typed: false
require 'rails_helper'

RSpec.describe AssignPbiToSprintUsecase do
  let!(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }
  let!(:pbi_b) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }
  let!(:pbi_c) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }
  let!(:roles) { team_roles(:po) }

  before do
    start_sprint(product.id)
  end

  it do
    described_class.perform(product.id, roles, pbi_c.id)
    described_class.perform(product.id, roles, pbi_a.id)
    described_class.perform(product.id, roles, pbi_b.id)

    stored_sprint = SprintRepository::AR.current(product.id)
    stored_pbi_a = PbiRepository::AR.find_by_id(pbi_a.id)
    stored_pbi_b = PbiRepository::AR.find_by_id(pbi_b.id)
    stored_pbi_c = PbiRepository::AR.find_by_id(pbi_c.id)

    aggregate_failures do
      expect(stored_sprint.items).to eq sbi_list_from_pbi(pbi_c.id, pbi_a.id, pbi_b.id)
      expect(stored_pbi_a.status).to be Pbi::Statuses.from_string('wip')
      expect(stored_pbi_b.status).to be Pbi::Statuses.from_string('wip')
      expect(stored_pbi_c.status).to be Pbi::Statuses.from_string('wip')
    end
  end

  xit do
    described_class.perform(product.id, roles, pbi_b.id)
    RevertPbiFromSprintUsecase.perform(product.id, roles, pbi_b.id)

    expect {
      described_class.perform(product.id, roles, pbi_b.id)
    }.to_not change(Dao::Work, :count)
  end

  it do
    SprintRepository::AR.current(product.id).tap do |sprint|
      sprint.finish
      SprintRepository::AR.store(sprint)
    end

    expect {
      described_class.perform(product.id, roles, pbi_c.id)
    }.to raise_error Sprint::NotStarted
  end
end
