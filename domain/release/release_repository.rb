# typed: strict
require 'sorbet-runtime'

module Release
  module ReleaseRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.returns(Integer)}
    def next_no; end
  end
end
