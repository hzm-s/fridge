# typed: strict
require 'sorbet-runtime'

module Release
  class Release
    extend T::Sig

    sig {params(item: Item).void}
    def add_item(item)
      @items << item
    end

    sig {params(item: Item).void}
    def remove_item(item)
      @items.delete(item)
    end

    sig {params(title: String).void}
    def modify_title(title)
      @title = title
    end

    sig {returns(T::Boolean)}
    def can_remove?
      @items.empty?
    end
  end
end
