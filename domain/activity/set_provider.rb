# typed: strict
require 'sorbet-runtime'

module Activity
  module SetProvider
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.returns(Set)}
    def available_activities; end
  end
end
