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

      sig {params(product_id: Product::Id, order: Order, scopes: ScopeSet).returns(T.attached_class)}
      def from_repository(product_id, order, scopes)
        new(product_id, order, scopes)
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Order)}
    attr_reader :order

    sig {returns(ScopeSet)}
    attr_reader :scopes

    sig {params(product_id: Product::Id, order: Order, scopes: ScopeSet).void}
    def initialize(product_id, order, scopes = ScopeSet.new)
      @product_id = product_id
      @order = order
      @scopes = scopes
      @__scoped ||= T.let(nil, T.nilable(T::Array[Release]))
    end

    sig {params(issue_id: Issue::Id).void}
    def append_issue(issue_id)
      @order = @order.append(issue_id)
    end

    sig {params(issue_id: Issue::Id).void}
    def remove_issue(issue_id)
      old_order = @order
      new_order = @order.remove(issue_id)
      @scopes = @scopes.on_remove_issue(old_order, new_order)
      @order = new_order
    end

    sig {params(from: Issue::Id, to: Issue::Id).void}
    def swap_issues(from, to)
      @order = @order.swap(from, to)
    end

    sig {params(release_id: String, tail: Issue::Id).void}
    def specify_release(release_id, tail)
      @scopes = @scopes.add(release_id, tail, @order)
    end

    sig {returns(T::Array[Release])}
    def scoped
      @__scoped ||= @scopes.make_releases(@order)
    end

    sig {returns(T::Array[Issue::Id])}
    def unscoped
      @order.to_a - scoped.flat_map(&:issues)
    end
  end
end
