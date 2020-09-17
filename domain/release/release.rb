# typed: strict
require 'sorbet-runtime'

module Release
  class Release
    extend T::Sig

    Item = T.type_alias {Pbi::Id}
    Items = T.type_alias {T::Array[Item]}

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(String)}
    attr_reader :title

    sig {returns(Items)}
    attr_reader :items

    sig {params(product_id: Product::Id, title: String, items: Items).void}
    def initialize(product_id, title, items)
      @product_id = product_id
      @title = title
      @items = items
    end

    sig {params(item: Item).returns(T.self_type)}
    def add_item(item)
      replace_items(@items + [item])
    end

    sig {params(item: Item).returns(T.self_type)}
    def remove_item(item)
      replace_items(@items.reject { |i| i == item })
    end

    sig {params(item: Item, to: Item).returns(T.self_type)}
    def swap_priorities(item, to)
      return self if item == to

      if T.must(@items.index(item)) > T.must(@items.index(to))
        remove_item(item).then { |r| r.insert_item_before(item, to) }
      else
        remove_item(item).then { |r| r.insert_item_after(item, to) }
      end
    end

    sig {params(title: String).returns(T.self_type)}
    def modify_title(title)
      self.class.new(@product_id, title, @items)
    end

    protected

    sig {params(item: Item, to: Item).returns(T.self_type)}
    def insert_item_before(item, to)
      index = T.must(@items.index(to))
      replace_items(@items.insert(index, item))
    end

    sig {params(item: Item, to: Item).returns(T.self_type)}
    def insert_item_after(item, to)
      index = 0 - (@items.size - T.must(@items.index(to)))
      replace_items(@items.insert(index, item))
    end

    private

    sig {params(items: Items).returns(T.self_type)}
    def replace_items(items)
      self.class.new(@product_id, @title, items)
    end
  end
end
