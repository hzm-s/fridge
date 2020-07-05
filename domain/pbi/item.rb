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
          content,
          Pbi::StoryPoint.unknown
        )
      end

      sig {params(id: Pbi::ItemId, content: Pbi::Content, size: Pbi::StoryPoint).returns(T.attached_class)}
      def from_repository(id, content, size)
        new(id, content, size)
      end
    end

    sig {returns(Pbi::ItemId)}
    attr_reader :id

    sig {returns(Pbi::Content)}
    attr_reader :content

    sig {returns(Pbi::StoryPoint)}
    attr_reader :size

    sig {params(id: Pbi::ItemId, content: Pbi::Content, point: Pbi::StoryPoint).void}
    def initialize(id, content, point)
      @id = id
      @content = content
      @size = point
    end
    private_class_method :new

    sig {params(point: Pbi::StoryPoint).void}
    def estimate_size(point)
      @size = point
    end

    sig {returns(Pbi::Status)}
    def status
      Pbi::Status::Preparation
    end
  end
end
