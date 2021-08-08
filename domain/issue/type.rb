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

    sig {abstract.params(roles: Team::RoleSet).returns(T::Boolean)}
    def can_update_acceptance?(roles); end

    sig {abstract.params(roles: Team::RoleSet).returns(T::Boolean)}
    def can_accept?(roles); end

    sig {abstract.params(criteria: AcceptanceCriteria).returns(T::Boolean)}
    def satisfied?(criteria); end

    sig {abstract.returns(T::Boolean)}
    def must_have_acceptance_criteria?; end

    sig {abstract.returns(T::Boolean)}
    def update_by_preparation?; end

    sig {abstract.returns(Activity::Activity)}
    def accept_issue_activity; end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
