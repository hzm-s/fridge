# typed: strong

require 'sorbet-runtime'

module Product
  class BacklogItemOrder
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: ProductId).returns(BacklogItemOrder)}
      def create(product_id)
        new(product_id, [])
      end

      sig {params(product_id: ProductId, pbi_ids: T::Array[BacklogItemId]).returns(BacklogItemOrder)}
      def from_repository(product_id, pbi_ids)
        new(product_id, pbi_ids)
      end
    end

    sig {returns(ProductId)}
    attr_reader :product_id

    sig {params(product_id: ProductId, pbi_ids: T::Array[BacklogItemId]).void}
    def initialize(product_id, pbi_ids)
      @product_id = product_id
      @product_backlog_item_ids = pbi_ids
    end
    private_class_method :new

    sig {params(pbi: BacklogItem).void}
    def append(pbi)
      @product_backlog_item_ids << pbi.id
    end

    sig {params(pbi_id: BacklogItemId).returns(T.nilable(Integer))}
    def position(pbi_id)
      @product_backlog_item_ids.index(pbi_id)
    end

    sig {returns(T::Array[BacklogItemId])}
    def to_a
      @product_backlog_item_ids
    end
  end
end
