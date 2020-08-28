# typed: strict
require 'sorbet-runtime'

module Pbi
  module PbiRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(id: Id).returns(Pbi)}
    def find_by_id(id); end

    sig {abstract.params(pbi: Pbi).void}
    def add(pbi); end

    sig {abstract.params(pbi: Pbi).void}
    def update(pbi); end

    sig {abstract.params(id: Id).void}
    def delete(id); end
  end
end
