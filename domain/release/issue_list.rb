# typed: strict
require 'sorbet-runtime'

module Release
  class IssueList
    extend T::Sig

    sig {params(items: T::Array[Issue::Id]).void}
    def initialize(items = [])
      @items = items
    end

    sig {params(item: Issue::Id).returns(T.self_type)}
    def append(item)
      self.class.new(@items + [item])
    end

    sig {params(item: Issue::Id).returns(T.self_type)}
    def add_to_first(item)
      self.class.new([item] + @items)
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

    sig {returns(T::Boolean)}
    def empty?
      to_a.empty?
    end

    sig {params(issue_id: Issue::Id).returns(T::Boolean)}
    def include?(issue_id)
      to_a.include?(issue_id)
    end

    sig {params(other: IssueList).returns(T::Boolean)}
    def have_same_issue?(other)
      (self.to_a & other.to_a).any?
    end

    sig {returns(T::Array[Issue::Id])}
    def to_a
      @items.dup
    end

    sig {params(other: IssueList).returns(T::Boolean)}
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