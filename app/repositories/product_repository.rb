# typed: strict
require 'sorbet-runtime'

module ProductRepository
  module AR
    class << self
      extend T::Sig
      include Product::ProductRepository

      sig {override.params(id: Product::Id).returns(Product::Product)}
      def find_by_id(id)
        r = Dao::Product.find(id)

        members = r.members.map do |m|
          Team::Member.new(User::Id.from_string(m.dao_user_id), Team::Role.deserialize(m.role))
        end

        Product::Product.from_repository(
          Product::Id.from_string(r.id),
          r.name,
          members,
          r.description
        )
      end

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

      sig {override.params(product: Product::Product).void}
      def update(product)
        r = Dao::Product.find(product.id)
        r.members = build_new_members(product)
        r.save!
      end

      private

      sig {params(product: Product::Product).returns(T::Array[Dao::TeamMember])}
      def build_new_members(product)
        product.members.map do |m|
          Dao::TeamMember.new(dao_product_id: product.id.to_s, dao_user_id: m.user_id.to_s, role: m.role.to_s)
        end
      end
    end
  end
end
