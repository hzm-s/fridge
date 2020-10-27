# typed: strict
require 'sorbet-runtime'

module Plan
  class ScopeSet
    extend T::Sig

    sig {params(scopes: T::Array[Scope]).void}
    def initialize(scopes = [])
      @scopes = scopes
    end

    sig {params(release_id: String, tail: Issue::Id, order: Order).returns(T.self_type)}
    def add(release_id, tail, order)
      scope = Scope.new(release_id, tail)
      new_scopes = (@scopes + [scope]).sort_by { |s| order.index(s.tail) }
      self.class.new(new_scopes)
    end

    sig {params(order: Order).returns(T::Array[Release])}
    def make_releases(order)
      scoped = []
      @scopes.each_with_index do |scope, i|
        previous =
          if i == 0
            nil
          else
            @scopes[i - 1]
          end
        scoped << scope.make_release(order, previous)
      end
      scoped
    end
  end
end
