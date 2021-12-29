# typed: false
require 'rails_helper'

describe ChangeSprintWorkPriorityUsecase do
  let(:product) { create_product }
  let!(:pbi_a) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:pbi_b) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let!(:pbi_c) { add_pbi(product.id, acceptance_criteria: %w(CRT), size: 3, release: 1, assign: true) }
  let(:roles) { team_roles(:po) }

  it do
    described_class.perform(product.id, roles, pbi_b.id, 0)

    sprint = SprintRepository::AR.current(product.id)

    expect(sprint.items).to eq pbi_list(pbi_b.id, pbi_a.id, pbi_c.id)
  end
end
