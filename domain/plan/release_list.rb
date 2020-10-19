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

    sig {params(order: Order).returns(Release::Expanded)}
    def expand(order)
      order.to_a.map do |issue_id|
        {
          issue_id: issue_id,
          release_id: find(issue_id, order)&.release_id
        }
      end
    end

    def describe(order)
      scheduled = @releases.map { |r| r.describe(order) }.to_h
      unscheduled_issues = order.to_a - scheduled.values.flatten
      scheduled.merge(nil => unscheduled_issues)
    end

    private

    def find(issue_id, order)
      @releases.find { |s| s.include?(issue_id, order) }
    end
  end
end
