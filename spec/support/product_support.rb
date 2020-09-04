# typed: false
require_relative '../domain_support/team_domain_support'

module ProductSpport
  include TeamDomainSupport

  def _create_product
    product = Product::Product.create('example', 'desc')
    ProductRepository::AR.add(product)
    product
  end

  def create_product(person_id: nil, name: 'example', description: 'desc example')
    person_id ||= sign_up_as_person.id

    CreateProductUsecase.new
      .perform(person_id, name, description)
      .yield_self { |id| ProductRepository::AR.find_by_id(id) }
  end

  def add_team_member(product_id, member)
    AddTeamMemberUsecase.perform(product_id, member.person_id, member.role)
  end
end

RSpec.configure do |c|
  c.include ProductSpport
end
