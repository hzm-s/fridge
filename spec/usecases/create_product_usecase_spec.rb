# typed: false
require 'rails_helper'

RSpec.describe CreateProductUsecase do
  let(:person) { sign_up_as_person }

  it do
    product_id = described_class.perform(person.id, Team::Role::ProductOwner, 'fridge', 'DESC')
    product = ProductRepository::AR.find_by_id(product_id)
    member = product.team_member(person.id)

    aggregate_failures do
      expect(product.name).to eq 'fridge'
      expect(product.description).to eq 'DESC'

      expect(member.person_id).to eq person.id
      expect(member.role.to_s).to eq 'product_owner'
    end
  end
end
