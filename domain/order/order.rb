# typed: strict
require 'sorbet-runtime'

module Order
  class Order
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id, IssueList.new([]))
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(IssueList)}
    attr_reader :issue_list

    sig {params(product_id: Product::Id, issue_list: IssueList).void}
    def initialize(product_id, issue_list)
      @product_id = product_id
      @issue_list = issue_list
    end
  end
end
