# typed: strict
require 'sorbet-runtime'

module Plan
  class Scope
    extend T::Sig

    Expanded = T.type_alias {T::Array[T::Hash[Symbol, T.any(Issue::Id, T.nilable(String))]]}

    sig {returns(String)}
    attr_reader :release_id

    sig {params(release_id: String, tail: Issue::Id).void}
    def initialize(release_id, tail)
      @release_id = release_id
      @tail = tail
    end

    def include?(issue_id, order)
      order.before?(issue_id, @tail)
    end
  end
end
