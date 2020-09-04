# typed: strict
require 'sorbet-runtime'

class CreateProductUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @product_repository = T.let(ProductRepository::AR, Product::ProductRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(person_id: Person::Id, name: String, description: T.nilable(String)).returns(Product::Id)}
  def perform(person_id, name, description = nil)
    product = Product::Product.create(person_id, name, description)

    plan = Plan::Plan.create(product.id)
    release = Plan::Release.create('Icebox')
    plan.add_release(release)

    transaction do
      @product_repository.add(product)
      @plan_repository.add(plan)
    end

    product.id
  end
end
