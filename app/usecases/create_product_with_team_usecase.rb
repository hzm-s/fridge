# typed: strict
require 'sorbet-runtime'

class CreateProductWithTeamUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @product_repository = T.let(ProductRepository::AR, Product::ProductRepository)
    @team_repository = T.let(TeamRepository::AR, Team::TeamRepository)
  end

  sig {params(person_id: Person::Id, roles: Team::RoleSet, name: String, description: T.nilable(String)).returns(Product::Id)}
  def perform(person_id, roles, name, description = nil)
    product_id = CreateProductUsecase.perform(name, description)

    team_id = CreateTeamUsecase.perform(person_id, roles, name)
    team = @team_repository.find_by_id(team_id)
    team.develop(product_id)
    @team_repository.store(team)

    product_id
  end
end
