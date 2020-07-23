# typed: true
module ProductSpport

  def create_product(user_id: User::Id.create, role: Team::Role::ProductOwner, name: 'example', description: 'desc example product')
    CreateProductUsecase.new
      .perform(user_id, role, name, description)
      .yield_self { |id| ProductRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include ProductSpport
end
