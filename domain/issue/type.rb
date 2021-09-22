# typed: strict
require 'sorbet-runtime'
require 'issue/status'

module Issue
  module Type
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.returns(Status)}
    def initial_status; end

    sig {abstract.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(T::Boolean)}
    def prepared?(criteria, size); end

    sig {abstract.params(accepted: T::Boolean, criteria: AcceptanceCriteria).returns(T::Boolean)}
    def can_accept?(accepted, criteria); end

    sig {abstract.returns(T::Boolean)}
    def must_have_acceptance_criteria?; end

    sig {abstract.returns(Symbol)}
    def accept_issue_activity; end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
