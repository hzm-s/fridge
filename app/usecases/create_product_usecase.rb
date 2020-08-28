# typed: strict
require 'sorbet-runtime'

class CreateProductUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @product_repository = T.let(ProductRepository::AR, Product::ProductRepository)
    @plan_repository = T.let(PlanRepository::AR, Plan::PlanRepository)
  end

  sig {params(person_id: Person::Id, role: Team::Role, name: String, description: T.nilable(String)).returns(Product::Id)}
  def perform(person_id, role, name, description = nil)
    product = Product::Product.create(name, description)

    member = Team::Member.new(person_id, role)
    product.add_team_member(member)

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
