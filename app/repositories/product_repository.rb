# typed: strict
require 'sorbet-runtime'

module ProductRepository
  module AR
    class << self
      extend T::Sig
      include Product::ProductRepository

      sig {override.params(product: Product::Product).void}
      def add(product)
        Dao::Product.new(
          id: product.id.to_s,
          name: product.name.to_s,
          description: product.description.to_s
        ) do |p|
          member = product.members.first
          p.members.build(dao_user_id: member.user_id.to_s, role: member.role.to_s) if member
          p.save!
        end
      end

      sig {override.params(id: Product::ProductId).returns(Product::Product)}
      def find_by_id(id)
        r = Dao::Product.find(id)

        members = r.members.map do |m|
          Team::Member.new(User::Id.from_string(m.dao_user_id), Team::Role.deserialize(m.role))
        end

        Product::Product.from_repository(
          Product::ProductId.from_string(r.id),
          r.name,
          members,
          r.description
        )
      end
    end
  end
end
