# typed: strict
require 'sorbet-runtime'

module Release
  class Release
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(repository: ReleaseRepository, title: String).returns(T.attached_class)}
      def create(repository, title)
        new(
          Id.create,
          repository.next_no,
          title,
          []
        )
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Integer)}
    attr_reader :no

    sig {returns(String)}
    attr_reader :title

    sig {returns(T::Array[Pbi::Id])}
    attr_reader :items

    sig {params(id: Id, no: Integer, title: String, items: T::Array[Pbi::Id]).void}
    def initialize(id, no, title, items)
      @id = id
      @no = no
      @title = title
      @items = items
    end
  end
end
