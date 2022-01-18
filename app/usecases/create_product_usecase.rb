# typed: strict
require 'sorbet-runtime'

class CreateProductUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @product_repository = T.let(ProductRepository::AR, Product::ProductRepository)
    @roadmap_repository = T.let(RoadmapRepository::AR, Roadmap::RoadmapRepository)
  end

  sig {params(name: Shared::Name, description: T.nilable(Shared::ShortSentence)).returns(Product::Id)}
  def perform(name, description)
    product = Product::Product.create(name, description)
    roadmap = Roadmap::Roadmap.create(product.id)

    transaction do
      @product_repository.store(product)
      @roadmap_repository.store(roadmap)
    end

    product.id
  end
end
