# typed: strict
require 'sorbet-runtime'

module Plan
  class Scope
    extend T::Sig

    sig {returns(String)}
    attr_reader :id

    sig {params(id: String, head: T.nilable(Issue::Id), tail: Issue::Id).void}
    def initialize(id, head, tail)
      @id = id
      @head = head
      @tail = tail
    end

    sig {params(order: Order).returns(Release)}
    def to_release(order)
      Release.new(@id, order.select_by_range(@head, @tail))
    end
  end
end
