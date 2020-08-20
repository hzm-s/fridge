# typed: strict
require 'sorbet-runtime'

class CreateProductUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(ProductRepository::AR, Product::ProductRepository)
  end

  sig {params(person_id: Person::Id, role: Team::Role, name: String, description: T.nilable(String)).returns(Product::Id)}
  def perform(person_id, role, name, description = nil)
    product = Product::Product.create(name, description)

    member = Team::Member.new(person_id, role)
    product.add_team_member(member)

    @repository.add(product)

    product.id
  end
end
