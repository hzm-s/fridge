# typed: false
module TeamListQuery
  class << self
    def call(person_id)
      Dao::Team.eager_load(:members).where(dao_team_members: { dao_person_id: person_id })
    end
  end
end
