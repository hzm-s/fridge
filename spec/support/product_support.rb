module ProductSpport

  def create_product(name: 'example')
    CreateProductUsecase
      .perform(name)
      .yield_self { |id| ProductRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include ProductSpport
end
