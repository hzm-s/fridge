# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    Item = T.type_alias {Pbi::Id}
    Items = T.type_alias {T::Array[Item]}

    class << self
      extend T::Sig

      sig {params(title: String).returns(T.attached_class)}
      def create(title)
        new(title, [])
      end

      sig {params(title: String, items: Items).returns(T.attached_class)}
      def from_repository(title, items)
        new(title, items)
      end
    end

    sig {returns(String)}
    attr_reader :title

    sig {returns(Items)}
    attr_reader :items

    sig {params(title: String, items: Items).void}
    def initialize(title, items)
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

    sig {params(from: Item, to: Item).void}
    def swap_priorities(from, to)
      if @items.index(from) > @items.index(to)
        remove_item(from)
        insert_item_after(from, to)
      else
        remove_item(from)
        insert_item_before(from, to)
      end
    end

    private

    sig {params(item: Item, to: Item).void}
    def insert_item_after(item, to)
      index = @items.index(to)
      @items.insert(index, item)
    end

    sig {params(item: Item, to: Item).void}
    def insert_item_before(item, to)
      index = @items.index(to)
      @items.insert(0 - index, item)
    end
  end
end
