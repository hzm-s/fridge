# typed: strict
require 'sorbet-runtime'

class CreateProductWithTeamUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @product_repository = T.let(ProductRepository::AR, Product::ProductRepository)
    @team_repository = T.let(TeamRepository::AR, Team::TeamRepository)
  end

  sig {params(person_id: Person::Id, role: Team::Role, name: String, description: T.nilable(String)).returns(Product::Id)}
  def perform(person_id, role, name, description = nil)
    product = Product::Product.create(name, description)

    team = Team::Team.create(name)
    team.develop(product.id)
    team.add_member(Team::Member.new(person_id, role))

    transaction do
      @product_repository.store(product)
      @team_repository.store(team)
      PreparePlanUsecase.perform(product.id)
    end

    product.id
  end
end
