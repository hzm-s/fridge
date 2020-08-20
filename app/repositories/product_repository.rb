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
        Product::Product.from_repository(
          r.product_id_as_do,
          r.name,
          r.team_as_do,
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
          member = product.team.to_a.first
          p.members.build(dao_person_id: member.person_id.to_s, role: member.role.to_s) if member
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
        product.team.to_a.map do |m|
          Dao::TeamMember.new(dao_product_id: product.id.to_s, dao_person_id: m.person_id.to_s, role: m.role.to_s)
        end
      end
    end
  end
end
