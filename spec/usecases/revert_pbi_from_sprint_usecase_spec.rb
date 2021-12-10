# typed: false
require 'rails_helper'

RSpec.describe RevertPbiFromSprintUsecase do
  let!(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:pbi_b) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:pbi_c) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:pbi_d) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1) }
  let(:sbi_a) { resolve_sbi(pbi_a.id) }
  let(:sbi_b) { resolve_sbi(pbi_b.id) }
  let(:sbi_c) { resolve_sbi(pbi_c.id) }
  let!(:roles) { team_roles(:po) }

  it do
    #accept_pbi(pbi_a)

    described_class.perform(product.id, roles, sbi_a.id)
    described_class.perform(product.id, roles, sbi_b.id)

    stored_sprint = SprintRepository::AR.current(product.id)
    stored_pbi_a = PbiRepository::AR.find_by_id(pbi_a.id)
    stored_pbi_b = PbiRepository::AR.find_by_id(pbi_b.id)
    stored_pbi_c = PbiRepository::AR.find_by_id(pbi_c.id)

    aggregate_failures do
      expect { SbiRepository::AR.find_by_id(sbi_a.id) }.to raise_error Sbi::NotFound
      expect { SbiRepository::AR.find_by_id(sbi_b.id) }.to raise_error Sbi::NotFound
      expect(stored_sprint.items).to eq sbi_list_from_pbi(pbi_c.id)
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
      described_class.perform(product.id, roles, sbi_c.id)
    }.to raise_error Sprint::NotStarted
  end
end
