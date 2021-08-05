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

    sig {abstract.params(status: Status, roles: Team::RoleSet).returns(T::Boolean)}
    def can_update_acceptance?(status, roles); end

    sig {abstract.params(criteria: AcceptanceCriteria).returns(T::Boolean)}
    def all_satisfied?(criteria); end

    sig {abstract.returns(T::Boolean)}
    def must_have_acceptance_criteria?; end

    sig {abstract.returns(T::Boolean)}
    def update_by_preparation?; end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
