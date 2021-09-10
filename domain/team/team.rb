# typed: strict
require 'sorbet-runtime'

module Team
  class Team
    extend T::Sig

    Members = T.type_alias {T::Array[Member]}

    OVERCAPACITY_ERRORS = T.let({
      Role::ProductOwner => TooManyProductOwner,
      Role::ScrumMaster => TooManyScrumMaster,
      Role::Developer => TooManyDeveloper,
    }, T::Hash[Role, Class])

    class << self
      extend T::Sig

      sig {params(name: Shared::Name).returns(T.attached_class)}
      def create(name)
        new(Id.create, name, nil, [])
      end

      sig {params(id: Id, name: Shared::Name, product: T.nilable(Product::Id), members: Members).returns(T.attached_class)}
      def from_repository(id, name, product, members)
        new(id, name, product, members)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Shared::Name)}
    attr_reader :name

    sig {returns(Members)}
    attr_reader :members

    sig {returns(T.nilable(Product::Id))}
    attr_reader :product

    sig {params(id: Id, name: Shared::Name, product: T.nilable(Product::Id), members: Members).void}
    def initialize(id, name, product, members)
      @id = id
      @name = name
      @product = product
      @members = members
    end
    private_class_method :new

    sig {params(product: Product::Id).void}
    def develop(product)
      @product = product
    end

    sig {params(new_member: Member).void}
    def add_member(new_member)
      validate_duplicate_join!(new_member)
      validate_roles_capacities!(new_member)

      @members << new_member
    end

    sig {params(person_id: Person::Id).returns(T.nilable(Member))}
    def member(person_id)
      @members.find { |member| member.same_person?(person_id) }
    end

    sig {returns(T::Array[Role])}
    def available_roles
      roles = []
      roles << Role::ProductOwner if count_of_role(Role::ProductOwner) == 0
      roles << Role::ScrumMaster if count_of_role(Role::ScrumMaster) == 0
      roles << Role::Developer if count_of_role(Role::Developer) <= 8
      roles
    end

    private

    sig {params(role: Role).returns(Integer)}
    def count_of_role(role)
      @members.select { |member| member.have_role?(role) }.size
    end

    sig {params(new_member: Member).void}
    def validate_duplicate_join!(new_member)
      raise AlreadyJoined if member(new_member.person_id)
    end

    sig {params(new_member: Member).void}
    def validate_roles_capacities!(new_member)
      new_member.roles.to_a.each do |role|
        raise T.must(OVERCAPACITY_ERRORS[role]) unless available_roles.include?(role)
      end
    end
  end
end
