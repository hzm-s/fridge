# typed: strict
require 'sorbet-runtime'

module Issue
  module Status
    extend T::Sig
    extend T::Helpers
    interface!

    include Activity::SetProvider

    sig {abstract.returns(T::Boolean)}
    def can_remove?; end

    sig {abstract.returns(T::Boolean)}
    def can_estimate?; end

    sig {abstract.returns(T::Boolean)}
    def can_sprint_assign?; end

    sig {abstract.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
    def update_by_preparation(criteria, size); end

    sig {abstract.returns(Status)}
    def assign_to_sprint; end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
