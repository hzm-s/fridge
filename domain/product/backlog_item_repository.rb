# typed: true
require 'sorbet-runtime'

module Product
  module BacklogItemRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(pbi: BacklogItem).void}
    def add(pbi); end

    sig {abstract.params(id: BacklogItemId).returns(BacklogItem)}
    def find_by_id(id); end
  end
end
