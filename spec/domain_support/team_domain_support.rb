# typed: false
module TeamDomainSupport
  def po_member(person_id)
    Team::Member.new(person_id, [Team::Role::ProductOwner])
  end

  def dev_member(person_id)
    Team::Member.new(person_id, [Team::Role::Developer])
  end

  def sm_member(person_id)
    Team::Member.new(person_id, [Team::Role::ScrumMaster])
  end
end

RSpec.configure do |c|
  c.include TeamDomainSupport
end
