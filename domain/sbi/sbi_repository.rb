# typed: strict
require 'sorbet-runtime'

module Sbi
  module SbiRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(pbi_id: Pbi::Id).returns(Sbi)}
    def find_by_pbi_id(pbi_id); end

    sig {abstract.params(sbi: Sbi).void}
    def store(sbi); end
  end
end
