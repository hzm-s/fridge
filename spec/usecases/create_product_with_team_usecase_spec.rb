# typed: false
require 'rails_helper'

describe CreateProductWithTeamUsecase do
  let(:person) { sign_up_as_person }

  it do
    roles = Team::RoleSet.new([Team::Role::Developer])
    product_id = described_class.perform(person.id, roles, name('fridge'), s_sentence('DESC'))

    product = ProductRepository::AR.find_by_id(product_id)
    team = resolve_team(product.id)
    roadmap = RoadmapRepository::AR.find_by_product_id(product_id)

    aggregate_failures do
      expect(product.name.to_s).to eq 'fridge'
      expect(product.description.to_s).to eq 'DESC'

      expect(team.member(person.id).roles).to eq roles

      expect(roadmap).to_not be_nil
    end
  end
end
