# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    sig {returns(String)}
    attr_reader :title

    sig {returns(ItemList)}
    attr_reader :items

    sig {params(title: String, items: ItemList).void}
    def initialize(title, items)
      @title = title
      @items = items
    end

    sig {params(item: ItemList::Item).returns(T.self_type)}
    def add_item(item)
      self.class.new(@title, @items.add_item(item))
    end

    sig {params(item: ItemList::Item).returns(T.self_type)}
    def remove_item(item)
      self.class.new(@title, @items.remove_item(item))
    end

    sig {params(item: ItemList::Item, to: ItemList::Item).returns(T.self_type)}
    def swap_priorities(item, to)
      self.class.new(@title, @items.swap_priorities(item, to))
    end

    sig {params(title: String).returns(T.self_type)}
    def modify_title(title)
      self.class.new(title, @items)
    end

    sig {returns(T::Boolean)}
    def can_remove?
      @items.empty?
    end

    sig {params(item: ItemList::Item).returns(T::Boolean)}
    def include?(item)
      @items.to_a.include?(item)
    end
  end
end
