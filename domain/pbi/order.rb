# typed: strict
require 'sorbet-runtime'

module Pbi
  class Order
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id, [])
      end

      sig {params(product_id: Product::Id, pbi_ids: T::Array[Id]).returns(T.attached_class)}
      def from_repository(product_id, pbi_ids)
        new(product_id, pbi_ids)
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {params(product_id: Product::Id, pbi_ids: T::Array[Id]).void}
    def initialize(product_id, pbi_ids)
      @product_id = product_id
      @item_ids = pbi_ids
    end
    private_class_method :new

    sig {params(pbi: Item).void}
    def append(pbi)
      @item_ids << pbi.id
    end

    sig {params(pbi_id: Id, to: Integer).void}
    def move_item_to(pbi_id, to)
      pos2val = @item_ids.map.with_index(1) { |id, i| [i * 10, id] }.to_h

      src_pos = pos2val.key(pbi_id)
      dst_pos = to * 10

      pos2val.delete(src_pos)
      if (src_pos - dst_pos).positive?
        pos2val[dst_pos - 1] = pbi_id
      else
        pos2val[dst_pos + 1] = pbi_id
      end

      @item_ids = pos2val.sort.map { |pair| pair[1] }
    end

    sig {params(pbi_id: Id).void}
    def delete(pbi_id)
      @item_ids.delete(pbi_id)
    end

    sig {returns(T::Array[Id])}
    def to_a
      @item_ids
    end
  end
end
