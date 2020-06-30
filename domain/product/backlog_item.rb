# typed: ignore
require 'securerandom'

module Product
  class BacklogItem
    class << self
      def create(content)
        new(
          BacklogItemId.generate,
          content
        )
      end

      alias_method :from_repository, :new
    end

    private_class_method :new

    attr_reader :id, :content

    def initialize(id, content)
      @id = id
      @content = content
    end

    def status
      BacklogItemStatus::Preparation
    end
  end
end
