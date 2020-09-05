# typed: false
require_relative '../domain_support/team_domain_support'

module ProductSpport
  include TeamDomainSupport

  def create_product(person_id: nil, name: 'xyz', description: 'desc', members: [])
    person_id ||= sign_up_as_person.id

    product =
      CreateProductUsecase
        .perform(person_id, name, description)
        .yield_self { |id| ProductRepository::AR.find_by_id(id) }

    return product if members.empty?

    CreateProductTeamUsecase.perform(product.id, product.name)

    return product
  end

  def add_team_member(product_id, member)
    AddTeamMemberUsecase.perform(product_id, member.person_id, member.role)
  end
end

RSpec.configure do |c|
  c.include ProductSpport
end
