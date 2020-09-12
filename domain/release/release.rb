# typed: strict
require 'sorbet-runtime'

module Release
  class Release
    extend T::Sig

    sig {returns(String)}
    attr_reader :title

    sig {returns(ItemList)}
    attr_reader :items

    sig {params(sequence: Sequence, title: String, items: ItemList).void}
    def initialize(sequence, title, items)
      @sequence = sequence
      @title = title
      @items = items
    end

    sig {params(item: ItemList::Item).returns(T.self_type)}
    def add_item(item)
      replace_items(@items.add_item(item))
    end

    sig {params(item: ItemList::Item).returns(T.self_type)}
    def remove_item(item)
      replace_items(@items.remove_item(item))
    end

    sig {params(item: ItemList::Item, to: ItemList::Item).returns(T.self_type)}
    def swap_priorities(item, to)
      replace_items(@items.swap_priorities(item, to))
    end

    sig {params(title: String).returns(T.self_type)}
    def modify_title(title)
      self.class.new(@sequence, title, @items)
    end

    sig {returns(T::Boolean)}
    def can_remove?
      @items.empty?
    end

    sig {params(item: ItemList::Item).returns(T::Boolean)}
    def include?(item)
      @items.to_a.include?(item)
    end

    private

    sig {params(items: ItemList).returns(T.self_type)}
    def replace_items(items)
      self.class.new(@sequence, @title, items)
    end
  end
end
