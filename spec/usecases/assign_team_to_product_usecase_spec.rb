# typed: false
require 'rails_helper'

RSpec.describe AssignTeamToProductUsecase do
  let(:product) { _create_product }
  let(:team) { create_team }

  it do
    described_class.perform(product.id, team.id)

    stored = ProductRepository::AR.find_by_id(product.id)

    expect(stored.teams).to include team.id
  end
end
