# typed: strict
require 'sorbet-runtime'

module Sbi
  module SbiRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(id: Pbi::Id).returns(Sbi)}
    def find_by_id(id); end

    sig {abstract.params(sbi: Sbi).void}
    def store(sbi); end

    sig {abstract.params(id: Id).void}
    def remove(id); end
  end
end
