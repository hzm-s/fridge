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
      uniq_scopes = @scopes.reject { |s| s.like?(scope) }
      new_scopes = (uniq_scopes + [scope]).sort_by { |s| order.index(s.tail) }
      self.class.new(new_scopes)
    end

    sig {params(old_order: Order, new_order: Order).returns(T.self_type)}
    def on_remove_issue(old_order, new_order)
      removed = (old_order - new_order).first
      return self unless removed

      change_scope = @scopes.find { |scope| scope.tail == removed }
      return self unless change_scope

      new_tail = old_order.before_of(removed)
      return self unless new_tail

      add(change_scope.release_id, new_tail, new_order)
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

    sig {params(other: ScopeSet).returns(T::Boolean)}
    def ==(other)
      self.scopes == other.scopes
    end

    protected

    sig {returns(T::Array[Scope])}
    attr_reader :scopes

    private

    sig {params(scope: Scope).returns(T.nilable(Scope))}
    def previous_scope(scope)
      i = T.must(@scopes.find_index { |s| s == scope })
      return nil if i == 0

      @scopes[i - 1]
    end
  end
end
