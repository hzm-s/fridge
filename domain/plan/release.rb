# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    Item = T.type_alias {Feature::Id}
    Items = T.type_alias {T::Array[Item]}

    class << self
      extend T::Sig

      sig {params(title: String).returns(T.attached_class)}
      def create(title)
        new(title, [])
      end
    end

    sig {returns(String)}
    attr_reader :title

    sig {returns(Items)}
    attr_reader :items

    sig {params(title: String, items: Items).void}
    def initialize(title, items)
      @title = title
      @items = items
    end
    private_class_method :new

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
