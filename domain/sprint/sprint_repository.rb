# typed: strict
require 'sorbet-runtime'

module Sprint
  module SprintRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(id: Id).returns(Sprint)}
    def find_by_id(id); end

    sig {abstract.params(product_id: Product::Id).returns(T.nilable(Sprint))}
    def current(product_id); end

    sig {abstract.params(product_id: Product::Id).returns(Integer)}
    def next_sprint_number(product_id); end

    sig {abstract.params(sprint: Sprint).void}
    def store(sprint); end
  end
end
