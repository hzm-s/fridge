# typed: strict
require 'sorbet-runtime'

module Pbi
  module PbiRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(pbi: Pbi).void}
    def store(pbi); end
  end
end
