# typed: false
require_relative '../domain_support/team_domain_support'

module ProductSpport
  include TeamDomainSupport

  def create_product(person: sign_up_as_person.id, roles: default_roles, name: 'xyz', description: 'desc', members: [])
    product =
      CreateProductWithTeamUsecase
        .perform(person, roles, name(name), s_sentence(description))
        .then { |id| ProductRepository::AR.find_by_id(id) }

    return product if members.empty?

    members.each { |m| add_team_member(resolve_team(product.id).id, m) }

    product
  end

  def add_team_member(team_id, member)
    AddTeamMemberUsecase.perform(team_id, member.person_id, member.roles)
  end

  private

  def default_roles
    Team::RoleSet.new([Team::Role::ProductOwner])
  end
end

RSpec.configure do |c|
  c.include ProductSpport
end
