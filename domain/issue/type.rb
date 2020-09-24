# typed: strict
require 'sorbet-runtime'

module Issue
  module Type
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.returns(T::Boolean)}
    def can_estimate?; end

    sig {abstract.returns(T::Boolean)}
    def must_have_acceptance_criteria?; end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
