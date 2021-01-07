# typed: false
module TeamDomainSupport
  ROLE_DICTIONARY = {
    po: Team::Role::ProductOwner,
    sm: Team::Role::ScrumMaster,
    dev: Team::Role::Developer,
  }

  def team_member(person_id, *role_names)
    roles = role_names.map { |n| ROLE_DICTIONARY[n.to_sym] }
    Team::Member.new(person_id, Team::RoleSet.new(roles))
  end

  def po_member(person_id)
    team_member(person_id, :po)
  end

  def dev_member(person_id)
    team_member(person_id, :dev)
  end

  def sm_member(person_id)
    team_member(person_id, :sm)
  end
end

RSpec.configure do |c|
  c.include TeamDomainSupport
end
