# typed: strict
require 'sorbet-runtime'

module ProductBacklog
  class ProductBacklog
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id)
      end
    end

    Items = T.type_alias {T::Array[Feature::Id]}

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Items)}
    attr_reader :items

    sig {params(product_id: Product::Id).void}
    def initialize(product_id)
      @product_id = product_id
      @items = T.let([], Items)
    end

    sig {params(item: Feature::Id).void}
    def add_item(item)
      @items << item
    end

    sig {params(item: Feature::Id).void}
    def remove_item(item)
      @items.delete(item)
    end

    sig {params(target: Feature::Id, to: Feature::Id).void}
    def move_priority_up_to(target, to)
      remove_item(target)
      insert_item_before(target, to)
    end

    sig {params(target: Feature::Id, to: Feature::Id).void}
    def move_priority_down_to(target, to)
      remove_item(target)
      insert_item_after(target, to)
    end

    private

    sig {params(item: Feature::Id, to: Feature::Id).void}
    def insert_item_before(item, to)
      index = @items.index(to)
      @items.insert(index, item)
    end

    sig {params(item: Feature::Id, to: Feature::Id).void}
    def insert_item_after(item, to)
      index = @items.index(to)
      @items.insert(0 - index, item)
    end
  end
end
