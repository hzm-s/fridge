# typed: strict
require 'sorbet-runtime'

module Release
  class ItemSorter
    extend T::Sig

    Result = T.type_alias {T::Array[Release]}

    sig {params(from: Release, item: Release::Item, to: Release, position: Integer).void}
    def initialize(from, item, to, position)
      @from = from
      @item = item
      @to = to
      @position = position
    end

    sig {returns(Result)}
    def sort
      if @from.id == @to.id
        sort_in_release
      else
        sort_between_another_release
      end
    end

    private

    sig {returns(Result)}
    def sort_in_release
      @from.sort_item(@item, @position)
      [@from]
    end

    sig {returns(Result)}
    def sort_between_another_release
      @from.remove_item(@item)
      @to.add_item(@item)
      @to.sort_item(@item, @position)
      [@from, @to]
    end
  end
end
