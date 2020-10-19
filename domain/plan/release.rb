# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    sig {returns(String)}
    attr_reader :id

    sig {params(id: String, head: T.nilable(Issue::Id), tail: Issue::Id).void}
    def initialize(id, head, tail)
      @id = id
      @head = head
      @tail = tail
    end

    sig {params(order: Order).returns(T::Hash[T.nilable(String), T::Array[Issue::Id]])}
    def describe(order)
      { @id => order.select_by_range(@head, @tail) }
    end
  end
end
