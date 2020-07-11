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
      pos2val = @item_ids.map.with_index(1) { |id, i| [i * 10, id] }.to_h

      src_pos = pos2val.key(src)
      dst_pos = pos2val.key(dst)

      pos2val.delete(src_pos)
      if (src_pos - dst_pos).positive?
        pos2val[dst_pos - 1] = src
      else
        pos2val[dst_pos + 1] = src
      end

      @item_ids = pos2val.sort.map { |pair| pair[1] }
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
