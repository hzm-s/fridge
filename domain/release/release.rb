# typed: strict
require 'sorbet-runtime'

module Release
  class Release
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, title: String).returns(T.attached_class)}
      def create(product_id, title)
        new(Id.create, product_id, title)
      end

      sig {params(id: Id, product_id: Product::Id, title: String).returns(T.attached_class)}
      def from_repository(id, product_id, title)
        new(id, product_id, title)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(String)}
    attr_reader :title

    sig {params(id: Id, product_id: Product::Id, title: String).void}
    def initialize(id, product_id, title)
      @id = id
      @product_id = product_id
      @title = title
    end
    private_class_method :new

    sig {params(title: String).void}
    def modify_title(title)
      @title = title
    end
  end
end
