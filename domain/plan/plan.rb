# typed: strict
require 'sorbet-runtime'

module Plan
  class Plan
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id, [Release.new])
      end
    end

    sig {params(product_id: Product::Id, releases: T::Array[Release]).void}
    def initialize(product_id, releases)
      @product_id = product_id
      @releases = releases
    end

    sig {params(item: Release::Item).void}
    def add_item(item)
      @releases[-1] = T.must(@releases[-1]).add(item)
    end

    sig {params(item: Release::Item).void}
    def remove_item(item)
      i = index_of_release(item)
      @releases[i] = T.must(@releases[i]).remove(item)
    end

    sig {params(item: Release::Item, release: Integer, pos: Integer).void}
    def move_item(item, release, pos)
      from_i = index_of_release(item)
      to_i = release - 1

      if from_i == to_i
        @releases[to_i] = T.must(@releases[from_i]).move_to(item, pos)
      else
        remove_item(item)
        @releases[to_i] = T.must(@releases[to_i]).add(item)
        move_item(item, to_i + 1, pos)
      end
    end

    sig {params(title: String).void}
    def add_release(title)
      @releases << Release.new(title)
    end

    sig {returns(T::Array[Release::Items])}
    def items
      @releases.map(&:items)
    end

    private

    sig {params(item: Release::Item).returns(Integer)}
    def index_of_release(item)
      @releases.find_index { |r| r.items.include?(item) } or raise RangeError
    end
  end
end
