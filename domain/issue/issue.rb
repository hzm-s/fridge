# typed: strict
require 'sorbet-runtime'

module Issue
  module Issue
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.returns(Id)}
    def id; end

    sig {abstract.returns(Product::Id)}
    def product_id; end

    sig {abstract.returns(Status)}
    def status; end

    sig {abstract.returns(Description)}
    def description; end
  end
end
