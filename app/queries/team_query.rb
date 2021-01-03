# typed: false
module TeamQuery
  class << self
    def call(id)
      team = Dao::Team.eager_load(members: { person: { user_account: :profile } }).find(id)
      Team.new(team)
    end
  end

  class Team < SimpleDelegator
    def members
      @__members ||= super.map { |m| Member.new(m) }
    end

    def product_owner
      members.find { |m| m.role == ::Team::Role::ProductOwner.to_s }
    end

    def developers
      members.select { |m| m.role == ::Team::Role::Developer.to_s }
    end

    def scrum_master
      members.find { |m| m.role == ::Team::Role::ScrumMaster.to_s }
    end
  end

  class Member < SimpleDelegator
    def person_id
      dao_person_id
    end

    def name
      person.name
    end

    def avatar
      {
        initials: person.user_account.initials,
        fgcolor: person.user_account.fgcolor,
        bgcolor: person.user_account.bgcolor,
      }
    end
  end
end
