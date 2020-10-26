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

    sig {returns(T::Array[Release])}
    attr_reader :scoped

    sig {returns(T::Array[Issue::Id])}
    attr_reader :unscoped

    sig {params(product_id: Product::Id, order: Order).void}
    def initialize(product_id, order)
      @product_id = product_id
      @order = order
      @scoped = []
      @unscoped = []
      @releases = []
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

    sig {params(title: String, tail: Issue::Id).void}
    def specify_release(title, tail)
      @releases << { title: title, tail_index: @order.index(tail) }
      sorted = @releases.sort_by { |r| r[:tail_index] }

      sorted.each_with_index do |r, i|
        head_index =
          if i == 0
            0
          else
            sorted[i - 1][:tail_index] - 1
          end
        @scoped << Release.new(r[:title], @order.to_a[head_index..r[:tail_index]])
      end
    end
  end
end
