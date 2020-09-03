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
          r.product_id,
          r.name,
          r.owner,
          r.description,
          r.teams
        )
      end

      sig {override.params(product: Product::Product).void}
      def add(product)
        Dao::Product.create!(
          id: product.id.to_s,
          name: product.name.to_s,
          description: product.description.to_s,
          owner_id: product.owner.to_s,
        )
      end

      sig {override.params(product: Product::Product).void}
      def update(product)
        r = Dao::Product.find(product.id)
        r.name = product.name
        r.description = product.description
        r.owner_id = product.owner.to_s

        r.developments.clear
        product.teams.each do |team_id|
          r.developments.build(dao_team_id: team_id.to_s)
        end

        r.save!
      end
    end
  end
end
