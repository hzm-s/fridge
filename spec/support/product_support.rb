# typed: true
module ProductSpport

  def create_product(user_id: nil, role: Team::Role::ProductOwner, name: 'example', description: 'desc example')
    user_id ||= register_user.id
    CreateProductUsecase.new
      .perform(user_id, role, name, description)
      .yield_self { |id| ProductRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include ProductSpport
end
