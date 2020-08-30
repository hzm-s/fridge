# typed: true
module ProductQuery
  class << self
    def call(person_id)
      Dao::Product.joins(:members).where(dao_team_members: { dao_person_id: person_id })
    end
  end
end
