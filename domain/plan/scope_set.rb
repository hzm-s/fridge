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
      scope = Scope.new(release_id, order.index(tail))
      self.class.new(@scopes + [scope])
    end

    def make_releases(order)
      scoped = []
      each_with_previous do |current, previous|
        scoped << current.make_release(order, previous)
      end
      scoped
    end

    private

    def each_with_previous
      @scopes.zip([nil] + @scopes[1..]).each { |c, p| yield(c, p) }
    end
  end
end
