class AddProductBacklogItemUsecase

  def initialize(pbi_repository = ProductBacklogItemRepository::AR, order_repository = ProductBacklogItemOrderRepository::AR)
    @pbi_repository = pbi_repository
    @order_repository = order_repository
  end

  def perform(product_id, content)
    pbi = Product::BacklogItem.create(content)

    order = find_order(Product::ProductId.from_string(product_id))
    order.append(pbi)

    ApplicationRecord.transaction do
      @pbi_repository.add(pbi)
      @order_repository.update(order)
    end

    pbi.id.to_s
  end

  private

  def find_order(product_id)
    order = @order_repository.find_by_product_id(product_id)
    return Product::BacklogItemOrder.create(product_id) unless order

    order
  end
end
