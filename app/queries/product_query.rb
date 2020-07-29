# typed: false
module ProductQuery
  class << self
    def call(user_id)
      Dao::Product.joins(:members).where(dao_team_members: { dao_user_id: user_id })
    end
  end
end
