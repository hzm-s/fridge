# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    Item = T.type_alias {Pbi::Id}
    Items = T.type_alias {T::Array[Item]}

    sig {returns(String)}
    attr_reader :title

    sig {returns(Items)}
    attr_reader :items

    sig {params(title: String, items: Items).void}
    def initialize(title = 'Untitled', items = [])
      @title = title
      @items = items
    end

    sig {params(item: Item).returns(Release)}
    def add(item)
      new_items = items + [item]
      self.class.new(@title, new_items)
    end

    sig {params(item: Item).returns(Release)}
    def remove(item)
      new_items = items.reject { |i| i == item }
      self.class.new(@title, new_items)
    end

    sig {params(item: Item, to: Integer).returns(Release)}
    def move_to(item, to)
      pos_to_items = @items.map.with_index(1) { |item, pos| [pos * 10, item] }.to_h

      src_pos = pos_to_items.key(item)
      dst_pos = to * 10

      pos_to_items.delete(src_pos)
      if (src_pos - dst_pos).positive?
        pos_to_items[dst_pos - 1] = item
      else
        pos_to_items[dst_pos + 1] = item
      end

      new_items = pos_to_items.sort.map { |pos, item| item }
      self.class.new(@title, new_items)
    end

    sig {params(title: String).returns(Release)}
    def change_title(title)
      self.class.new(title, items)
    end

    sig {returns(T::Hash[Symbol, T.any(String, T::Array[String])])}
    def to_h
      { title: @title, items: items.map(&:to_s) }
    end

    sig {params(other: Release).returns(T::Boolean)}
    def ==(other)
      self.to_h == other.to_h
    end
  end
end
