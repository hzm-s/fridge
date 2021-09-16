# typed: strict
require 'sorbet-runtime'

class CreateProductUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @product_repository = T.let(ProductRepository::AR, Product::ProductRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(name: Shared::Name, description: T.nilable(Shared::ShortSentence)).returns(Product::Id)}
  def perform(name, description)
    product = Product::Product.create(name, description)
    plan = Plan::Plan.create(product.id)

    transaction do
      @product_repository.store(product)
      @plan_repository.store(plan)
    end

    product.id
  end
end
