# typed: strict
require 'sorbet-runtime'

module Pbi
  class Item
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(content: Pbi::Content).returns(T.attached_class)}
      def create(content)
        new(
          Pbi::ItemId.create,
          content
        )
      end

      sig {params(id: Pbi::ItemId, content: Pbi::Content).returns(T.attached_class)}
      def from_repository(id, content)
        new(id, content)
      end
    end

    sig {returns(Pbi::ItemId)}
    attr_reader :id

    sig {returns(Pbi::Content)}
    attr_reader :content

    sig {params(id: Pbi::ItemId, content: Pbi::Content).void}
    def initialize(id, content)
      @id = id
      @content = content
    end
    private_class_method :new

    sig {returns(Pbi::Status)}
    def status
      Pbi::Status::Preparation
    end
  end
end
