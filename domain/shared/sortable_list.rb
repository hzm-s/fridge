# typed: strict
require 'sorbet-runtime'

module Shared
  class SortableList
    extend T::Sig

    class NotFound < StandardError; end

    sig {params(items: T::Array[Sortable]).void}
    def initialize(items = [])
      @items = items
    end

    sig {params(item: Sortable).returns(T.self_type)}
    def append(item)
      self.class.new(@items + [item])
    end

    sig {params(item: Sortable).returns(T.self_type)}
    def remove(item)
      self.class.new(@items.reject { |i| i == item })
    end

    sig {params(from: Sortable, to: Sortable).returns(T.self_type)}
    def swap(from, to)
      return self if from == to

      if T.must(@items.index(from)) > T.must(@items.index(to))
        remove(from).then { |list| list.insert_before(from, to) }
      else
        remove(from).then { |list| list.insert_after(from, to) }
      end
    end

    sig {returns(T::Boolean)}
    def empty?
      to_a.empty?
    end

    sig {params(item_id: Sortable).returns(T::Boolean)}
    def include?(item_id)
      to_a.include?(item_id)
    end

    sig {params(index: Integer).returns(Sortable)}
    def index_of(index)
      raise NotFound unless found = to_a[index]

      found
    end

    sig {returns(T::Array[Sortable])}
    def to_a
      @items.dup
    end

    sig {params(other: SortableList).returns(T::Boolean)}
    def ==(other)
      self.to_a == other.to_a
    end

    protected

    sig {params(item: Sortable, to: Sortable).returns(T.self_type)}
    def insert_before(item, to)
      index = T.must(@items.index(to))
      self.class.new(@items.insert(index, item))
    end

    sig {params(item: Sortable, to: Sortable).returns(T.self_type)}
    def insert_after(item, to)
      index = 0 - (@items.size - T.must(@items.index(to)))
      self.class.new(@items.insert(index, item))
    end
  end
end
