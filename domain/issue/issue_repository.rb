# typed: strict
require 'sorbet-runtime'

module Issue
  module IssueRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(id: Id).returns(Issue)}
    def find_by_id(id); end

    sig {abstract.params(issue: Issue).void}
    def store(issue); end

    sig {abstract.params(id: Id).void}
    def delete(id); end
  end
end
