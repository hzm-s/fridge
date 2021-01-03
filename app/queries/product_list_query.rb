# typed: false
module ProductListQuery
  class << self
    def call(person_id)
      Dao::Product.joins(teams: :members).where(dao_team_members: { dao_person_id: person_id })
    end
  end
end
