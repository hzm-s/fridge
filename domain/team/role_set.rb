# typed: strict
require 'sorbet-runtime'
require 'set'

module Team
  class RoleSet
    extend T::Sig

    sig {returns(T::Set[Role])}
    attr_reader :roles

    sig {params(roles: T::Array[Role]).void}
    def initialize(roles)
      role_set = Set.new(roles)
      raise MemberHasTooManyRoles if role_set.size >= 3
      raise InvalidMultipleRoles if role_set == Set.new([Role::ProductOwner, Role::Developer])

      @roles = Set.new(role_set)
    end

    sig {returns(T::Array[Role])}
    def to_a
      @roles.to_a
    end

    sig {params(other: RoleSet).returns(T::Boolean)}
    def ==(other)
      self.roles == other.roles
    end
  end
end
