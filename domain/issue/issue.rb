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

    sig {abstract.params(description: Description).void}
    def modify_description(description); end

    sig {abstract.void}
    def start_development; end

    sig {abstract.void}
    def abort_development; end
  end
end
