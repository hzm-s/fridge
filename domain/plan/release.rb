# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(number: Integer, title: T.nilable(Shared::Name)).returns(T.attached_class)}
      def create(number, title = nil)
        title ||= Shared::Name.new("Release##{number}")
        new(number, title, Pbi::List.new)
      end

      sig {params(number: Integer, title: Shared::Name, items: Pbi::List).returns(T.attached_class)}
      def from_repository(number, title, items)
        new(number, title, items)
      end
    end

    sig {returns(Integer)}
    attr_reader :number

    sig {returns(Shared::Name)}
    attr_reader :title

    sig {returns(Pbi::List)}
    attr_reader :items

    sig {params(number: Integer, title: Shared::Name, items: Pbi::List).void}
    def initialize(number, title, items)
      @number= number
      @title = title
      @items = items
    end

    sig {params(item: Pbi::Id).void}
    def plan_item(item)
      raise DuplicatedItem if @items.include?(item)

      @items = @items.append(item)
    end

    sig {params(item: Pbi::Id).void}
    def drop_item(item)
      @items = @items.remove(item)
    end

    sig {params(from: Pbi::Id, to: Pbi::Id).void}
    def change_item_priority(from, to)
      @items = @items.swap(from, to)
    end

    sig {params(title: Shared::Name).void}
    def modify_title(title)
      @title = title
    end

    sig {returns(T::Boolean)}
    def can_remove?
      @items.empty?
    end

    sig {params(item: Pbi::Id).returns(T::Boolean)}
    def planned?(item)
      @items.include?(item)
    end

    sig {params(other: Release).returns(T::Boolean)}
    def ==(other)
      self.number == other.number
    end

    sig {params(other: Release).returns(Integer)}
    def <=>(other)
      self.number <=> other.number
    end
  end
end
