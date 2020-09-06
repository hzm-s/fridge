# typed: false
module ProductListQuery
  class << self
    def call(person_id)
      as_owner = Dao::Product.eager_load(owner_person: { user_account: :profile }).where(owner_id: person_id)
      as_member = Dao::Product.joins(teams: :members).where(dao_team_members: { dao_person_id: person_id })
      (as_owner + as_member).uniq.map { |p| Product.new(p) }
    end
  end

  class Product < SimpleDelegator
    def owner_avatar
      {
        initials: owner_person.user_account.initials,
        fgcolor: owner_person.user_account.fgcolor,
        bgcolor: owner_person.user_account.bgcolor,
      }
    end
  end
end
