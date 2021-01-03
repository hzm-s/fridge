# typed: strict
require 'sorbet-runtime'

module Team
  class Team
    extend T::Sig

    Members = T.type_alias {T::Array[Member]}

    OVERCAPACITY_ERRORS = {
      Role::ProductOwner => TooManyProductOwner,
      Role::ScrumMaster => TooManyScrumMaster,
      Role::Developer => TooManyDeveloper,
    }

    class << self
      extend T::Sig

      sig {params(name: String).returns(T.attached_class)}
      def create(name)
        new(Id.create, name, nil, [])
      end

      sig {params(id: Id, name: String, product: Product::Id, members: Members).returns(T.attached_class)}
      def from_repository(id, name, product, members)
        new(id, name, product, members)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(String)}
    attr_reader :name

    sig {returns(Members)}
    attr_reader :members

    sig {returns(T.nilable(Product::Id))}
    attr_reader :product

    sig {params(id: Id, name: String, product: T.nilable(Product::Id), members: Members).void}
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

    sig {params(member: Member).void}
    def add_member(member)
      raise AlreadyJoined if self.member(member.person_id)
      raise OVERCAPACITY_ERRORS[member.role] unless available_roles.include?(member.role)

      @members << member
    end

    sig {params(person_id: Person::Id).returns(T.nilable(Member))}
    def member(person_id)
      @members.find { |member| member.person_id == person_id }
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
      @members.select { |member| member.role == role }.size
    end
  end
end
