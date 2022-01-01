# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    #class << self
    #  extend T::Sig

    #  sig {params(number: Integer, title: T.nilable(Shared::Name)).returns(T.attached_class)}
    #  def create(number, title = nil)
    #    title ||= Shared::Name.new("Release##{number}")
    #    new(number, title, Shared::SortableList.new)
    #  end

    #  sig {params(number: Integer, title: Shared::Name, items: Shared::SortableList).returns(T.attached_class)}
    #  def from_repository(number, title, items)
    #    new(number, title, items)
    #  end
    #end

    sig {returns(Integer)}
    attr_reader :number

    sig {returns(Shared::Name)}
    attr_reader :title

    sig {returns(Shared::SortableList)}
    attr_reader :items

    sig {params(number: Integer, title: T.nilable(Shared::Name), items: T.nilable(Shared::SortableList)).void}
    def initialize(number, title = nil, items = nil)
      @number= number
      @title = title || Shared::Name.new("Release##{number}")
      @items = items || Shared::SortableList.new
    end

    sig {params(item: Pbi::Id).returns(T.self_type)}
    def plan_item(item)
      raise DuplicatedItem if items.include?(item)

      self.class.new(number, title, items.append(item))
    end

    sig {params(item: Pbi::Id).returns(T.self_type)}
    def drop_item(item)
      self.class.new(number, title, items.remove(item))
    end

    sig {params(from: Pbi::Id, to: Pbi::Id).returns(T.self_type)}
    def change_item_priority(from, to)
      self.class.new(number, title, items.swap(from, to))
    end

    sig {params(title: Shared::Name).returns(T.self_type)}
    def modify_title(title)
      self.class.new(number, title, items)
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
