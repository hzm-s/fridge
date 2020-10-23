# typed: strict
require 'sorbet-runtime'

module Plan
  class Scope
    extend T::Sig

    sig {returns(Issue::Id)}
    attr_reader :tail

    sig {params(id: String, tail: Issue::Id).void}
    def initialize(id, tail)
      @id = id
      @tail = tail
    end

    sig {params(previous: T.nilable(Scope), order: Order).returns(Release)}
    def to_release(previous, order)
      head = previous && order.next_of(previous.tail)
      Release.new(@id, order.select_by_range(head, @tail))
    end
  end
end
