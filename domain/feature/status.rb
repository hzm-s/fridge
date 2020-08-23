# typed: strict
require 'sorbet-runtime'

module Feature
  module Status
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.returns(T::Boolean)}
    def can_assign?; end

    sig {abstract.returns(T::Boolean)}
    def can_cancel_assignment?; end

    sig {abstract.returns(T::Boolean)}
    def can_remove?; end

    sig {abstract.returns(T::Boolean)}
    def can_estimate_size?; end

    sig {abstract.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
    def update_by_prepartion(criteria, size); end

    sig {abstract.returns(Status)}
    def update_to_wip; end

    sig {abstract.returns(Status)}
    def update_by_cancel_assignment; end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
