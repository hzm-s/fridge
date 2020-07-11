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
      @item_ids = pbi_ids
    end
    private_class_method :new

    sig {params(pbi: Pbi::Item).void}
    def append(pbi)
      @item_ids << pbi.id
    end

    sig {params(src: Pbi::ItemId, dst: Pbi::ItemId).void}
    def move_item_to(src, dst)
      map = @item_ids.map.with_index(1) { |id, i| [i, id] }.to_h

      src_key = map.key(src)
      dst_key = map.key(dst)

      map.delete(src_key)
      if (dst_key - src_key).positive?
        map[dst_key + 0.1] = src
      else
        map[dst_key - 0.1] = src
      end

      @item_ids = map.sort.map { |pair| pair[1] }
    end

    sig {params(pbi_id: Pbi::ItemId).returns(T.nilable(Integer))}
    def position(pbi_id)
      @item_ids.index(pbi_id)
    end

    sig {returns(T::Array[Pbi::ItemId])}
    def to_a
      @item_ids
    end
  end
end
