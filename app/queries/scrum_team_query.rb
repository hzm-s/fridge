# typed: false
require 'sorbet-runtime'

module ScrumTeamQuery
  class << self
    def call(person_id, product_id)
      po =
        Dao::Product.find(product_id).owner_id
          .yield_self { |id| Member.new(person_id: id, role: :product_owner) }

      members =
        Dao::TeamMember
          .joins(team: :product)
          .where(dao_person_id: person_id)
          .where(dao_products: { id: product_id })
        .map { |tm| Member.new(person_id: tm.dao_person_id, role: tm.role.to_sym) }

      ScrumTeam.new([po] + members)
    end
  end

  class ScrumTeam < SimpleDelegator
    def role(person_id)
      select { |m| m.person_id == person_id }
        .map(&:role)
        .yield_self { |roles| Role.new(roles) }
    end
  end

  class Role < SimpleDelegator
  end

  class Member < T::Struct
    prop :person_id, String
    prop :role, Symbol
  end
end
