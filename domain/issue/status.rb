# typed: strict
require 'sorbet-runtime'

module Issue
  module Status
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.returns(T::Boolean)}
    def can_start_development?; end

    sig {abstract.returns(T::Boolean)}
    def can_abort_development?; end

    sig {abstract.returns(T::Boolean)}
    def can_remove?; end

    sig {abstract.returns(T::Boolean)}
    def can_estimate?; end

    sig {abstract.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
    def update_by_prepartion(criteria, size); end

    sig {abstract.returns(Status)}
    def update_to_wip; end

    sig {abstract.returns(Status)}
    def update_by_abort_development; end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
