# typed: strict
require 'sorbet-runtime'

module Requirement
  module Kind
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.returns(String)}
    def to_s; end
  end
end
