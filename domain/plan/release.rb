# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    Expanded = T.type_alias {T::Array[T::Hash[Symbol, T.any(Issue::Id, T.nilable(String))]]}

    sig {returns(String)}
    attr_reader :id

    sig {params(id: String, head: T.nilable(Issue::Id), tail: Issue::Id).void}
    def initialize(id, head, tail)
      @id = id
      @head = head
      @tail = tail
    end

    def describe(order)
      [@id, order.select_by_range(@head, @tail)]
    end

    def include?(issue_id, order)
      order.before?(issue_id, @tail)
    end
  end
end
