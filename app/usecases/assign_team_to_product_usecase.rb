# typed: strict
require 'sorbet-runtime'

class AssignTeamToProductUsecase < UsecaseBase
  extend T::Sig

  def initialize
    @repository = T.let(ProductRepository::AR, Product::ProductRepository)
  end

  sig {params(product_id: Product::Id, team_id: Team::Id).void}
  def perform(product_id, team_id)
    product = @repository.find_by_id(product_id)
    product.assign_team(team_id)
    @repository.update(product)
  end
end
