# typed: strict
require 'sorbet-runtime'

module Plan
  class Plan
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id, Order.new([]))
      end

      sig {params(product_id: Product::Id, issues: Order).returns(T.attached_class)}
      def from_repository(product_id, issues)
        new(product_id, issues)
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Order)}
    attr_reader :order

    sig {params(product_id: Product::Id, order: Order).void}
    def initialize(product_id, order)
      @product_id = product_id
      @order = order
    end

    sig {params(issue_id: Issue::Id).void}
    def append_issue(issue_id)
      @order = @order.append(issue_id)
    end

    sig {params(issue_id: Issue::Id).void}
    def remove_issue(issue_id)
      @order = @order.remove(issue_id)
    end

    sig {params(from: Issue::Id, to: Issue::Id).void}
    def swap_issues(from, to)
      @order = @order.swap(from, to)
    end
  end
end
