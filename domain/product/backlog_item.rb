# typed: strict
require 'sorbet-runtime'

module Product
  class BacklogItem
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(content: BacklogItemContent).returns(T.attached_class)}
      def create(content)
        new(
          BacklogItemId.create,
          content
        )
      end

      sig {params(id: BacklogItemId, content: BacklogItemContent).returns(T.attached_class)}
      def from_repository(id, content)
        new(id, content)
      end
    end

    sig {returns(BacklogItemId)}
    attr_reader :id

    sig {returns(BacklogItemContent)}
    attr_reader :content

    sig {params(id: BacklogItemId, content: BacklogItemContent).void}
    def initialize(id, content)
      @id = id
      @content = content
    end
    private_class_method :new

    sig {returns(BacklogItemStatus)}
    def status
      BacklogItemStatus::Preparation
    end
  end
end
