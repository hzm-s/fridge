# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    sig {params(items: T::Array[Pbi::Id]).void}
    def initialize(items = [])
      @items = items
    end

    sig {params(pbi_id: Pbi::Id).void}
    def add(pbi_id)
      @items << pbi_id
    end

    sig {params(pbi_id: Pbi::Id, to: Integer).void}
    def move_item_to(pbi_id, to)
      pos_to_items = @items.map.with_index(1) { |item, pos| [pos * 10, item] }.to_h

      src_pos = pos_to_items.key(pbi_id)
      dst_pos = to * 10

      pos_to_items.delete(src_pos)
      if (src_pos - dst_pos).positive?
        pos_to_items[dst_pos - 1] = pbi_id
      else
        pos_to_items[dst_pos + 1] = pbi_id
      end

      @items = pos_to_items.sort.map { |pos, item| item }
    end

    sig {returns(T::Array[Pbi::Id])}
    def to_a
      @items
    end
  end
end
