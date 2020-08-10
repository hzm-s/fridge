# typed: false
module TeamDomainSupport
  def po_member(user_id)
    Team::Member.new(user_id, Team::Role::ProductOwner)
  end

  def dev_member(user_id)
    Team::Member.new(user_id, Team::Role::Developer)
  end

  def sm_member(user_id)
    Team::Member.new(user_id, Team::Role::ScrumMaster)
  end
end

RSpec.configure do |c|
  c.include TeamDomainSupport
end
