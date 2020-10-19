# typed: strict
require 'sorbet-runtime'

module Plan
  class ReleaseList
    extend T::Sig

    sig {params(releases: T::Array[Release]).void}
    def initialize(releases)
      @releases = releases
    end

    sig {params(release_id: String, tail: Issue::Id).returns(T.self_type)}
    def add(release_id, tail)
      head = nil
      release = Release.new(release_id, head, tail)
      self.class.new(@releases + [release])
    end

    sig {params(order: Order).returns(T::Hash[T.nilable(String), T::Array[Issue::Id]])}
    def describe(order)
      scoped = @releases.reduce({}) { |m, r| m.merge(r.describe(order)) }
      loose = order.to_a - scoped.values.flatten
      scoped.merge(nil => loose)
    end
  end
end
