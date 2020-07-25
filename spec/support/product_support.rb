# typed: false
module ProductSpport
  def create_product(user_id: nil, role: Team::Role::ProductOwner, name: 'example', description: 'desc example')
    user_id ||= register_user.id
    CreateProductUsecase.new
      .perform(user_id, role, name, description)
      .yield_self { |id| ProductRepository::AR.find_by_id(id) }
  end

  def add_team_member(product_id, member)
    AddTeamMemberUsecase.perform(product_id, member.user_id, member.role)
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
  c.include ProductSpport
end
