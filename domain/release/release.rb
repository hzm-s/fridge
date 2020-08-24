# typed: strict
require 'sorbet-runtime'

module Release
  class Release
    extend T::Sig

    Item = T.type_alias {Feature::Id}
    Items = T.type_alias {T::Array[Item]}

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, title: String).returns(T.attached_class)}
      def create(product_id, title)
        new(Id.create, product_id, title, [])
      end

      sig {params(id: Id, product_id: Product::Id, title: String, items: Items).returns(T.attached_class)}
      def from_repository(id, product_id, title, items)
        new(id, product_id, title, items)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(String)}
    attr_reader :title

    sig {returns(Items)}
    attr_reader :items

    sig {params(id: Id, product_id: Product::Id, title: String, items: Items).void}
    def initialize(id, product_id, title, items)
      @id = id
      @product_id = product_id
      @title = title
      @items = items
    end
    private_class_method :new

    sig {params(item: Item).void}
    def add_item(item)
      @items << item
    end

    sig {params(item: Item).void}
    def remove_item(item)
      @items.delete(item)
    end

    sig {params(title: String).void}
    def modify_title(title)
      @title = title
    end

    sig {returns(T::Boolean)}
    def can_remove?
      @items.empty?
    end
  end
end
