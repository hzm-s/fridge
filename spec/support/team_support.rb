# typed: false
module TeamSupport
  def create_team(name: 'The A Team', person_id: nil, role: nil)
    person_id ||= sign_up_as_person.id
    role ||= Team::Role.from_string('developer')

    CreateTeamUsecase.perform(name, person_id, role)
      .yield_self { |id| TeamRepository::AR.find_by_id(id) }
  end

  def resolve_team(product_id)
    Dao::Team.find_by(dao_product_id: product_id.to_s)
      .yield_self { |t| Team::Id.from_string(t.id) }
      .yield_self { |id| TeamRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include TeamSupport
end
