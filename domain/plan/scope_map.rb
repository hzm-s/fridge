# typed: strict
require 'sorbet-runtime'

module Plan
  class ScopeMap
    extend T::Sig

    sig {params(scopes: T::Array[Scope]).void}
    def initialize(scopes)
      @scopes = scopes
    end

    sig {params(release_id: String, tail: Issue::Id).returns(T.self_type)}
    def register(release_id, tail)
      scope = Scope.new(release_id, tail)
      self.class.new(@scopes + [scope])
    end

    sig {params(order: Order).returns(T::Array[Release])}
    def to_releases(order)
      fixed = @scopes.map { |s| s.to_release(previous_of(s), order) }
      loose = Release.new(nil, order.to_a - fixed.flat_map(&:issues))
      fixed + [loose]
    end

    private

    def previous_of(scope)
    end
  end
end
