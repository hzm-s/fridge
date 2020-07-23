# typed: strict
require 'sorbet-runtime'

module Product
  class Product
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(name: String, member: Team::Member, description: T.nilable(String)).returns(T.attached_class)}
      def create(name, member, description = nil)
        new(
          ProductId.create,
          name,
          [member],
          description
        )
      end

      sig {params(id: ProductId, name: String, members: T::Array[Team::Member], description: T.nilable(String)).returns(T.attached_class)}
      def from_repository(id, name, members, description)
        new(id, name, members, description)
      end
    end

    sig {returns(::Product::ProductId)}
    attr_reader :id

    sig {returns(String)}
    attr_reader :name

    sig {returns(T.nilable(String))}
    attr_reader :description

    sig {returns(T::Array[Team::Member])}
    attr_reader :members

    sig {params(id: ProductId, name: String, members: T::Array[Team::Member], description: T.nilable(String)).void}
    def initialize(id, name, members, description)
      @id = id
      @name = name
      @members = members
      @description = description
    end

    sig {params(user_id: User::Id).returns(T.nilable(Team::Member))}
    def member(user_id)
      @members.find { |member| member.user_id == user_id }
    end
  end
end
