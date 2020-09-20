# typed: false
module TeamListQuery
  class << self
    def call(person_id)
      teams = Dao::Team.eager_load(:members).where(dao_team_members: { dao_person_id: person_id })
      Development.new(teams)
    end
  end

  class Development < T::Struct
    prop :team, Dao::Team
  end
end
