# typed: strict
require 'sorbet-runtime'

class AddTeamMemberUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductRepository::AR, Product::ProductRepository)
  end

  sig {params(product_id: Product::Id, user_id: User::Id, role: Team::Role).void}
  def perform(product_id, user_id, role)
    product = @repository.find_by_id(product_id)

    member = Team::Member.new(user_id, role)
    product.add_team_member(member)

    @repository.update(product)
  end
end
