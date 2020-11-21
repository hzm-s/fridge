# typed: strict
require 'sorbet-runtime'

module Plan
  module IssueContainer
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(other: IssueContainer).returns(T::Boolean)}
    def have_same_issue?(other); end
  end
end
