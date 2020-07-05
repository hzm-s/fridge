# typed: strict
require 'sorbet-runtime'

module Pbi
  module ItemRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(id: Pbi::ItemId).returns(Pbi::Item)}
    def find_by_id(id); end

    sig {abstract.params(pbi: Pbi::Item).void}
    def add(pbi); end

    sig {abstract.params(pbi: Pbi::Item).void}
    def update(pbi); end
  end
end
