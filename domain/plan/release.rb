# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    Item = T.type_alias {Pbi::Id}
    Items = T.type_alias {T::Array[Item]}

    sig {returns(String)}
    attr_reader :title

    sig {returns(Items)}
    attr_reader :items

    sig {params(title: String, items: Items).void}
    def initialize(title, items)
      @title = title
      @items = items
    end

    sig {params(item: Item).returns(Release)}
    def add_item(item)
      self.class.new(@title, @items + [item])
    end

    sig {params(item: Item).returns(Release)}
    def remove_item(item)
      self.class.new(@title, @items.reject { |i| i == item })
    end

    sig {params(title: String).returns(Release)}
    def modify_title(title)
      self.class.new(title, @items)
    end

    sig {returns(T::Boolean)}
    def can_remove?
      @items.empty?
    end

    sig {params(from: Item, to: Item).returns(Release)}
    def swap_priorities(from, to)
      return self if from == to

      if T.must(@items.index(from)) > T.must(@items.index(to))
        remove_item(from).yield_self { |me| me.insert_item_before(from, to) }
      else
        remove_item(from).yield_self { |me| me.insert_item_after(from, to) }
      end
    end

    sig {params(item: Item).returns(T::Boolean)}
    def include?(item)
      @items.include?(item)
    end

    protected

    sig {params(item: Item, to: Item).returns(Release)}
    def insert_item_before(item, to)
      index = T.must(@items.index(to))
      self.class.new(@title, @items.insert(index, item))
    end

    sig {params(item: Item, to: Item).returns(Release)}
    def insert_item_after(item, to)
      index = 0 - (@items.size - T.must(@items.index(to)))
      self.class.new(@title, @items.insert(index, item))
    end
  end
end
