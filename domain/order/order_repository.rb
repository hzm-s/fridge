# typed: strict
require 'sorbet-runtime'

module Order
  module OrderRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(order: Order).void}
    def store(order); end
  end
end
