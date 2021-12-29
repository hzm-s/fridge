# typed: false
require 'rails_helper'

describe RevertPbiFromSprintUsecase do
  let!(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:pbi_b) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:pbi_c) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:pbi_d) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }
  let!(:roles) { team_roles(:po) }

  it do
    #accept_pbi(pbi_a)

    described_class.perform(product.id, roles, pbi_a.id)
    described_class.perform(product.id, roles, pbi_b.id)

    stored_sprint = SprintRepository::AR.current(product.id)
    stored_pbi_a = PbiRepository::AR.find_by_id(pbi_a.id)
    stored_pbi_b = PbiRepository::AR.find_by_id(pbi_b.id)
    stored_pbi_c = PbiRepository::AR.find_by_id(pbi_c.id)

    aggregate_failures do
      expect(stored_sprint.items).to eq pbi_list(pbi_c.id)
      expect(stored_pbi_a.status).to be Pbi::Statuses::Ready
      expect(stored_pbi_b.status).to be Pbi::Statuses::Ready
      expect(stored_pbi_c.status).to be Pbi::Statuses::Wip
    end
  end

  it 'スプリントが終了している場合は取り消しできないこと' do
    SprintRepository::AR.current(product.id).tap do |sprint|
      sprint.finish
      SprintRepository::AR.store(sprint)
    end

    expect {
      described_class.perform(product.id, roles, pbi_c.id)
    }.to raise_error Sprint::NotStarted
  end
end
