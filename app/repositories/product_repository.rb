module ProductRepository
  module AR
    module_function

    def add(product)
      Dao::Product.create!(
        id: product.id.to_s,
        name: product.name.to_s,
        description: product.description.to_s
      )
    end
  end
end
