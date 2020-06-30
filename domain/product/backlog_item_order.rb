module Product
  class BacklogItemOrder
    class << self
      def create(product_id)
        new(product_id, [])
      end

      def from_repository(product_id, product_backlog_item_ids)
        new(product_id, product_backlog_item_ids)
      end
    end

    private_class_method :new

    attr_reader :product_id

    def initialize(product_id, product_backlog_item_ids)
      @product_id = product_id
      @product_backlog_item_ids = product_backlog_item_ids
    end

    def append(product_backlog_item)
      @product_backlog_item_ids << product_backlog_item.id
    end

    def position(product_backlog_item_id)
      @product_backlog_item_ids.index(product_backlog_item_id)
    end

    def to_a
      @product_backlog_item_ids
    end
  end
end
