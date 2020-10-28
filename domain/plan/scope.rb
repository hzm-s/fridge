# typed: strict
require 'sorbet-runtime'

module Plan
  class Scope
    extend T::Sig

    sig {returns(Issue::Id)}
    attr_reader :tail

    sig {params(release_id: String, tail: Issue::Id).void}
    def initialize(release_id, tail)
      @release_id = release_id
      @tail = tail
    end

    sig {params(order: Order, previous: T.nilable(Scope)).returns(Release)}
    def make_release(order, previous)
      Release.new(@release_id, order.subset(previous&.tail, @tail))
    end

    sig {params(other: T.nilable(Scope)).returns(T::Boolean)}
    def ==(other)
      self.to_h == other.to_h
    end

    protected

    sig {returns(T::Hash[Symbol, T.any(String, Issue::Id)])}
    def to_h
      { release_id: @release_id, tail: @tail }
    end
  end
end
