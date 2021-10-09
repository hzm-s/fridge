# typed: strict
require 'sorbet-runtime'

module Work
  module Status
    extend T::Sig
    extend T::Helpers
    interface!

    include Activity::SetProvider

    sig {abstract.returns(Issue::Type)}
    def issue_type; end

    sig {abstract.params(acceptance: Acceptance).returns(Status)}
    def update_by_acceptance(acceptance); end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
