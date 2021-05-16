# typed: strict
require 'sorbet-runtime'

module Work
  module WorkRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(issue_id: Issue::Id).returns(Work)}
    def find_by_issue_id(issue_id); end

    sig {abstract.params(work: Work).void}
    def store(work); end
  end
end
