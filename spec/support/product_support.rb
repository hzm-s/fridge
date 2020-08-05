# typed: false
require_relative '../domain_support/team_domain_support'

module ProductSpport
  include TeamDomainSupport

  def create_product(user_id: nil, role: Team::Role::ProductOwner, name: 'example', description: 'desc example')
    user_id ||= register_user.id
    CreateProductUsecase.new
      .perform(user_id, role, name, description)
      .yield_self { |id| ProductRepository::AR.find_by_id(id) }
  end

  def add_team_member(product_id, member)
    AddTeamMemberUsecase.perform(product_id, member.user_id, member.role)
  end
end

RSpec.configure do |c|
  c.include ProductSpport
end
