# typed: strict
require 'sorbet-runtime'

module Release
  class Release
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, title: String, previous_release_id: T.nilable(Id)).returns(T.attached_class)}
      def create(product_id, title, previous_release_id = nil)
        new(
          Id.create,
          product_id,
          previous_release_id,
          title,
          ItemList.new([])
        )
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(T.nilable(Id))}
    attr_reader :previous_release_id

    sig {returns(String)}
    attr_reader :title

    sig {returns(ItemList)}
    attr_reader :items

    sig {params(id: Id, product_id: Product::Id, previous_release_id: T.nilable(Id), title: String, items: ItemList).void}
    def initialize(id, product_id, previous_release_id, title, items)
      @id = id
      @product_id = product_id
      @previous_release_id = previous_release_id
      @title = title
      @items = items
    end
    private_class_method :new

    sig {params(item: ItemList::Item).void}
    def add_item(item)
      @items = @items.add_item(item)
    end

    sig {params(item: ItemList::Item).void}
    def remove_item(item)
      @items = @items.remove_item(item)
    end

    sig {params(item: ItemList::Item, to: ItemList::Item).void}
    def swap_priorities(item, to)
      @items = @items.swap_priorities(item, to)
    end

    sig {params(title: String).void}
    def modify_title(title)
      @title = title
    end

    sig {returns(T::Boolean)}
    def can_remove?
      @items.empty?
    end

    private

    sig {params(items: ItemList).returns(T.self_type)}
    def replace_items(items)
      self.class.new(@sequence, @title, items)
    end
  end
end
