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
        previous = previous_scope(scope)
        scoped << scope.make_release(order, previous)
      end
      scoped
    end

    private

    sig {params(scope: Scope).returns(T.nilable(Scope))}
    def previous_scope(scope)
      i = T.must(@scopes.find_index { |s| s == scope })
      return nil if i == 0

      @scopes[i - 1]
    end
  end
end
