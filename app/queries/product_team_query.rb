# typed: false
require 'sorbet-runtime'

module ProductTeamQuery
  class << self
    def call(product_id, person_id)
      members =
        Dao::TeamMember
          .joins(team: :product)
          .where(dao_person_id: person_id)
          .where(dao_products: { id: product_id })
          .map { |m| Member.new(person_id: m.dao_person_id, role: m.role.to_sym) }

      ProductTeam.new(members)
    end
  end

  class ProductTeam < SimpleDelegator
    def role(person_id)
      select { |m| m.person_id == person_id }
        .map(&:role)
        .yield_self { |roles| Role.new(roles) }
    end
  end

  class Role < SimpleDelegator
    def translate(scope)
      map { |role| I18n.t(role, scope: scope) }.join('/')
    end
  end

  class Member < T::Struct
    prop :person_id, String
    prop :role, Symbol
  end
end
