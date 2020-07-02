# typed: strict
require 'sorbet-runtime'

class CreateProductUsecase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductRepository::AR, Product::ProductRepository)
  end

  sig {params(name: String).returns(Product::ProductId)}
  def perform(name)
    product = Product::Product.create(name)

    @repository.add(product)

    product.id
  end
end
