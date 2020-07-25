# typed: false
module TeamQuery
  class Member < SimpleDelegator
    def user_id
      dao_user_id
    end

    def name
      user.name
    end

    def initials
      user.initials
    end

    def avatar_fg
      user.avatar.fg
    end

    def avatar_bg
      user.avatar.bg
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
      members = Dao::TeamMember.eager_load(user: :avatar).where(dao_product_id: product_id).order(:id)
      Team.new(product_id, members.map { |m| Member.new(m) })
    end
  end
end
