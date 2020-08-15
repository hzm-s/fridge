# typed: strict
require 'sorbet-runtime'

module Release
  class Release
    extend T::Sig

    Item = T.type_alias {Pbi::Id}
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

    sig {params(item: Item, new_positon: Integer).void}
    def sort_item(item, new_positon)
      pos_to_items = @items.map.with_index(1) { |item, pos| [pos * 10, item] }.to_h

      src_pos = pos_to_items.key(item)
      dst_pos = new_positon * 10

      pos_to_items.delete(src_pos)
      if (src_pos - dst_pos).positive?
        pos_to_items[dst_pos - 1] = item
      else
        pos_to_items[dst_pos + 1] = item
      end

      @items = pos_to_items.sort.map { |pos, item| item }
    end

    sig {params(title: String).void}
    def change_title(title)
      @title = title
    end

    sig {returns(T::Boolean)}
    def can_remove?
      @items.empty?
    end
  end
end
