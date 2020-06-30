module Product
  class Product
    attr_reader :id, :name, :description

    def initialize(name)
      @id = ProductId.generate
      @name = name
    end
  end
end
