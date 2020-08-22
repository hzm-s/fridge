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

    Items = T.type_alias {T::Array[Item]}

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Items)}
    attr_reader :items

    sig {params(product_id: Product::Id).void}
    def initialize(product_id)
      @product_id = product_id
      @items = T.let([], Items)
    end

    sig {params(feature_id: Feature::Id).void}
    def add_item(feature_id)
      @items << Item.new(feature_id)
    end

    sig {params(feature_id: Feature::Id).void}
    def remove_item(feature_id)
      @items.reject! { |item| item.id == feature_id }
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

    sig {params(feature_id: Feature::Id, to: Feature::Id).void}
    def insert_item_before(feature_id, to)
      index = @items.find_index { |item| item.id == to }
      @items.insert(index, Item.new(feature_id))
    end

    sig {params(feature_id: Feature::Id, to: Feature::Id).void}
    def insert_item_after(feature_id, to)
      index = @items.find_index { |item| item.id == to }
      @items.insert(0 - index, Item.new(feature_id))
    end
  end
end
