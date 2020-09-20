# typed: strict
require 'sorbet-runtime'

module Release
  class Release
    extend T::Sig

    Item = T.type_alias {Issue::Id}

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, title: String).returns(T.attached_class)}
      def create(product_id, title)
        new(Id.create, product_id, title, ItemList.new([]))
      end

      sig {params(id: Id, product_id: Product::Id, title: String, items: ItemList).returns(T.attached_class)}
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

    sig {returns(ItemList)}
    attr_reader :items

    sig {params(id: Id, product_id: Product::Id, title: String, items: ItemList).void}
    def initialize(id, product_id, title, items)
      @id = id
      @product_id = product_id
      @title = title
      @items = items
    end
    private_class_method :new

    sig {params(item: Item).void}
    def add_item(item)
      @items = @items.add_item(item)
    end

    sig {params(item: Item).void}
    def remove_item(item)
      @items = @items.remove_item(item)
    end

    sig {params(item: Item, to: Item).void}
    def swap_priorities(item, to)
      @items = @items.swap_priorities(item, to)
    end

    sig {params(index: Integer).returns(Item)}
    def fetch_item(index)
      @items.to_a[index]
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
