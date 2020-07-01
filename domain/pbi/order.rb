# typed: strict
require 'sorbet-runtime'

module Pbi
  class Order
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::ProductId).returns(T.attached_class)}
      def create(product_id)
        new(product_id, [])
      end

      sig {params(product_id: Product::ProductId, pbi_ids: T::Array[Pbi::ItemId]).returns(T.attached_class)}
      def from_repository(product_id, pbi_ids)
        new(product_id, pbi_ids)
      end
    end

    sig {returns(Product::ProductId)}
    attr_reader :product_id

    sig {params(product_id: Product::ProductId, pbi_ids: T::Array[Pbi::ItemId]).void}
    def initialize(product_id, pbi_ids)
      @product_id = product_id
      @product_backlog_item_ids = pbi_ids
    end
    private_class_method :new

    sig {params(pbi: Pbi::Item).void}
    def append(pbi)
      @product_backlog_item_ids << pbi.id
    end

    sig {params(pbi_id: Pbi::ItemId).returns(T.nilable(Integer))}
    def position(pbi_id)
      @product_backlog_item_ids.index(pbi_id)
    end

    sig {returns(T::Array[Pbi::ItemId])}
    def to_a
      @product_backlog_item_ids
    end
  end
end
