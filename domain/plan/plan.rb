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

      sig {params(product_id: Product::Id, releases: T::Array[Release]).returns(T.attached_class)}
      def from_repository(product_id, releases)
        new(product_id, releases)
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(T::Array[Release])}
    attr_reader :releases

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
      no = no_of_release(item)
      @releases[no - 1] = release(no).remove(item)
    end

    sig {params(item: Release::Item, no: Integer, pos: Integer).void}
    def move_item(item, no, pos)
      from_no = no_of_release(item)
      from_i = from_no - 1
      to_i = no - 1

      if from_i == to_i
        @releases[to_i] = release(from_no).move_to(item, pos)
      else
        remove_item(item)
        @releases[to_i] = release(no).add(item)
        move_item(item, no, pos)
      end
    end

    sig {params(title: String).void}
    def add_release(title)
      @releases << Release.new(title)
    end

    sig {params(no: Integer, title: String).void}
    def change_release_title(no, title)
      @releases[no - 1] = release(no).change_title(title)
    end

    sig {params(no: Integer).returns(Release)}
    def release(no)
      T.must(@releases[no - 1])
    end

    sig {returns(T::Array[Release::Items])}
    def items
      @releases.map(&:items)
    end

    private

    sig {params(item: Release::Item).returns(Integer)}
    def no_of_release(item)
      index = @releases.find_index { |r| r.items.include?(item) } or raise RangeError
      index + 1
    end
  end
end
