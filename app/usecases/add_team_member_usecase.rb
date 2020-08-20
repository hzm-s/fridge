# typed: strict
require 'sorbet-runtime'

class AddTeamMemberUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductRepository::AR, Product::ProductRepository)
  end

  sig {params(product_id: Product::Id, person_id: Person::Id, role: Team::Role).void}
  def perform(product_id, person_id, role)
    product = @repository.find_by_id(product_id)

    member = Team::Member.new(person_id, role)
    product.add_team_member(member)

    @repository.update(product)
  end
end
