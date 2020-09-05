# typed: false
require_relative '../domain_support/team_domain_support'

module ProductSpport
  include TeamDomainSupport

  def create_product(owner: nil, name: 'xyz', description: 'desc', members: [])
    owner ||= sign_up_as_person.id

    product =
      CreateProductUsecase
        .perform(owner, name, description)
        .yield_self { |id| ProductRepository::AR.find_by_id(id) }

    return product if members.empty?

    CreateProductTeamUsecase.perform(product.id, "#{product.name}-dev")

    return product
  end

  def add_team_member(product_id, member)
    AddTeamMemberUsecase.perform(product_id, member.person_id, member.role)
  end
end

RSpec.configure do |c|
  c.include ProductSpport
end
