require 'securerandom'

module Product
  class BacklogItem
    attr_reader :id, :content

    def initialize(content)
      @id = SecureRandom.uuid
      @content = content
    end

    def status
      BacklogItemStatus::Preparation
    end
  end
end
