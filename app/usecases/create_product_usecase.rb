# typed: strict
require 'sorbet-runtime'

class CreateProductUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @product_repository = T.let(ProductRepository::AR, Product::ProductRepository)
  end

  sig {params(person_id: Person::Id, name: String, description: T.nilable(String)).returns(Product::Id)}
  def perform(person_id, name, description = nil)
    product = Product::Product.create(person_id, name, description)
    @product_repository.add(product)
    product.id
  end
end
