# typed: false
module TeamQuery
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

  class Team < SimpleDelegator
    attr_reader :product_id

    def initialize(product_id, members)
      super(members)
      @product_id = product_id
    end

    def product_owner
      find { |m| m.role == ::Team::Role::ProductOwner.to_s }
    end

    def developers
      select { |m| m.role == ::Team::Role::Developer.to_s }
    end

    def scrum_master
      find { |m| m.role == ::Team::Role::ScrumMaster.to_s }
    end
  end

  class << self
    def call(product_id)
      members = Dao::TeamMember.eager_load(person: { user_account: :profile }).where(dao_product_id: product_id).order(:id)
      Team.new(product_id, members.map { |m| Member.new(m) })
    end
  end
end
