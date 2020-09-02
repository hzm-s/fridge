# typed: false
module TeamSupport
  def create_team(name: 'The A Team', person_id: nil, role: nil)
    person_id ||= sign_up_as_person.id
    role ||= Team::Role.from_string('developer')

    CreateTeamUsecase.perform(name, person_id, role)
      .yield_self { |id| TeamRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include TeamSupport
end
