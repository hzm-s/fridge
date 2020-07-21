# typed: strict
require 'sorbet-runtime'

class CreateProductUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductRepository::AR, Product::ProductRepository)
  end

  sig {params(user_id: User::Id, name: String, description: T.nilable(String)).returns(Product::ProductId)}
  def perform(user_id, name, description = nil)
    product = Product::Product.create(name, description)

    @repository.add(product)

    product.id
  end
end
