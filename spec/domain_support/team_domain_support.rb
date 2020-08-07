# typed: false
module TeamDomainSupport
  def register_user(name: 'User Name', email: 'us@example.com')
    User::User.create(name, email)
  end

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
