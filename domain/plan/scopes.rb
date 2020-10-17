# typed: strict
require 'sorbet-runtime'

module Plan
  class Scopes
    extend T::Sig

    sig {params(scopes: T::Array[Scope]).void}
    def initialize(scopes)
      @scopes = scopes
    end

    sig {params(scope: Scope).returns(T.self_type)}
    def add(scope)
      self.class.new(@scopes + [scope])
    end

    sig {params(order: Order).returns(Scope::Expanded)}
    def expand(order)
      order.to_a.map do |issue_id|
        {
          issue_id: issue_id,
          release_id: find(issue_id, order)&.release_id
        }
      end
    end

    private

    def find(issue_id, order)
      @scopes.find { |s| s.include?(issue_id, order) }
    end
  end
end
