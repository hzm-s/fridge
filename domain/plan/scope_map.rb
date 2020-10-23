# typed: strict
require 'sorbet-runtime'

module Plan
  class ScopeMap
    extend T::Sig

    sig {params(scopes: T::Array[Scope]).void}
    def initialize(scopes)
      @scopes = scopes
    end

    sig {params(release_id: String, tail: Issue::Id, order: Order).returns(T.self_type)}
    def register(release_id, tail, order)
      (@scopes + [Scope.new(release_id, tail)])
        .then { |scopes| scopes.sort_by { |s| order.index(s.tail) } }
        .then { |scopes| self.class.new(scopes) }
    end

    sig {params(order: Order).returns(T::Array[Release])}
    def to_releases(order)
      known = @scopes.map.with_index do |s, i|
        previous = i == 0 ? nil : @scopes[i - 1]
        s.to_release(previous, order)
      end
      unknown = Release.new(nil, order.to_a - known.flat_map(&:issues))
      known + [unknown]
    end
  end
end
