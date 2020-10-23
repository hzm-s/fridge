# typed: strict
require 'sorbet-runtime'

module Plan
  class Order
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
    def remove(item)
      self.class.new(@items.reject { |i| i == item })
    end

    sig {params(from: Issue::Id, to: Issue::Id).returns(T.self_type)}
    def swap(from, to)
      return self if from == to

      if T.must(@items.index(from)) > T.must(@items.index(to))
        remove(from).then { |list| list.insert_before(from, to) }
      else
        remove(from).then { |list| list.insert_after(from, to) }
      end
    end

    sig {params(head: T.nilable(Issue::Id), tail: Issue::Id).returns(T::Array[Issue::Id])}
    def select_by_range(head, tail)
      head_i = @items.index(head) || 0
      tail_i = @items.index(tail)
      T.must(@items[head_i..tail_i])
    end

    sig {returns(T::Boolean)}
    def empty?
      @items.empty?
    end

    sig {params(index: Integer).returns(Issue::Id)}
    def at(index)
      @items.at(index)
    end

    sig {params(issue: Issue::Id).returns(Integer)}
    def index(issue)
      @items.index(issue)
    end

    sig {returns(T::Array[Issue::Id])}
    def to_a
      @items
    end

    sig {params(other: Order).returns(T::Boolean)}
    def ==(other)
      self.to_a == other.to_a
    end

    protected

    sig {params(item: Issue::Id, to: Issue::Id).returns(T.self_type)}
    def insert_before(item, to)
      index = T.must(@items.index(to))
      self.class.new(@items.insert(index, item))
    end

    sig {params(item: Issue::Id, to: Issue::Id).returns(T.self_type)}
    def insert_after(item, to)
      index = 0 - (@items.size - T.must(@items.index(to)))
      self.class.new(@items.insert(index, item))
    end
  end
end
