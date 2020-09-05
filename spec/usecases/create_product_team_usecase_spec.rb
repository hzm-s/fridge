# typed: false
require 'rails_helper'

RSpec.describe CreateProductTeamUsecase do
  let(:product) { create_product }

  it do
    team_id = described_class.perform(product.id, 'ABC')

    team = TeamRepository::AR.find_by_id(team_id)

    aggregate_failures do
      expect(team.name).to eq 'ABC'
      expect(team.members).to be_empty
      expect(team.product).to eq product.id
    end
  end
end
