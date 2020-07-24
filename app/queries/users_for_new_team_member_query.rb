# typed: false
module UsersForNewTeamMemberQuery
  class << self
    def call(product_id)
      all = Dao::User.all
      members = Dao::User.joins(:team_members).where(dao_team_members: { dao_product_id: product_id })
      all - members
    end
  end
end
