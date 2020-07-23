# typed: strict
require 'sorbet-runtime'

class CreateProductUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductRepository::AR, Product::ProductRepository)
  end

  sig {params(user_id: User::Id, role: Team::Role, name: String, description: T.nilable(String)).returns(Product::ProductId)}
  def perform(user_id, role, name, description = nil)
    member = Team::Member.new(user_id, role)
    product = Product::Product.create(name, member, description)

    @repository.add(product)

    product.id
  end
end
