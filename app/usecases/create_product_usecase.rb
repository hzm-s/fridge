# typed: strict
require 'sorbet-runtime'

class CreateProductUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductRepository::AR, Product::ProductRepository)
  end

  sig {params(name: String, description: T.nilable(String)).returns(Product::ProductId)}
  def perform(name, description = nil)
    product = Product::Product.create(name, description)

    @repository.add(product)

    product.id
  end
end
