# typed: strict
require 'sorbet-runtime'

module Order
  class List
    extend T::Sig

    sig {params(items: T::Array[Issue::Id]).void}
    def initialize(items)
      @items = items
    end

    sig {params(item: Issue::Id).returns(T.self_type)}
    def append(item)
      self.class.new(@items + [item])
    end

    sig {params(item: Issue::Id).returns(T.self_type)}
    def remove_item(item)
      self.class.new(@items.reject { |i| i == item })
    end

    sig {params(item: Issue::Id, to: Issue::Id).returns(T.self_type)}
    def swap_priorities(item, to)
      return self if item == to

      if T.must(@items.index(item)) > T.must(@items.index(to))
        remove_item(item).yield_self { |me| me.insert_item_before(item, to) }
      else
        remove_item(item).yield_self { |me| me.insert_item_after(item, to) }
      end
    end

    sig {returns(T::Boolean)}
    def empty?
      to_a.empty?
    end

    sig {returns(T::Array[Issue::Id])}
    def to_a
      @items
    end

    sig {params(other: T::Array[Issue::Id]).returns(T::Boolean)}
    def ==(other)
      self.to_a == other.to_a
    end

    protected

    sig {params(item: Issue::Id, to: Issue::Id).returns(T.self_type)}
    def insert_item_before(item, to)
      index = T.must(@items.index(to))
      self.class.new(@items.insert(index, item))
    end

    sig {params(item: Issue::Id, to: Issue::Id).returns(T.self_type)}
    def insert_item_after(item, to)
      index = 0 - (@items.size - T.must(@items.index(to)))
      self.class.new(@items.insert(index, item))
    end
  end
end
