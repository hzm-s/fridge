# typed: true
module ProductListQuery
  class << self
    def call(person_id)
      as_owner = Dao::Product.where(owner_id: person_id)
      as_member = Dao::Product.joins(teams: :members).where(dao_team_members: { dao_person_id: person_id })
      (as_owner + as_member).uniq
    end
  end
end
