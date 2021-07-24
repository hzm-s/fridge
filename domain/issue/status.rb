# typed: strict
require 'sorbet-runtime'

module Issue
  module Status
    extend T::Sig
    extend T::Helpers
    interface!

    include Activity::SetProvider

    sig {abstract.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
    def update_by_preparation(criteria, size); end

    sig {abstract.returns(Status)}
    def assign_to_sprint; end

    sig {abstract.returns(Status)}
    def revert_from_sprint; end

    sig {abstract.params(criteria: AcceptanceCriteria).returns(Status)}
    def update_by_acceptance(criteria); end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
