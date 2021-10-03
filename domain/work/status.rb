# typed: strict
require 'sorbet-runtime'

module Work
  module Status
    extend T::Sig
    extend T::Helpers
    interface!

    include Activity::SetProvider

    sig {abstract.returns(String)}
    def to_s; end
  end
end
