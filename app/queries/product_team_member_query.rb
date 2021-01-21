# typed: false
module ProductTeamMemberQuery
  class << self
    def call(product_id, person_id)
      Dao::TeamMember
        .joins(team: :product)
        .find_by(dao_products: { id: product_id }, dao_person_id: person_id)
        .then { |rel| TeamMemberStruct.new(rel) }
    end
  end

  class TeamMemberStruct < SimpleDelegator
    def can_change_issue_priority?
      roles.can_change_issue_priority?
    end

    def roles
      @__roles =
        super
          .map { |r| Team::Role.from_string(r) }
          .then { |rs| Team::RoleSet.new(rs) }
    end
  end
end
