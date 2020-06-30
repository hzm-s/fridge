class AddProductBacklogItemUsecase

  def initialize(repository = Product::BacklogItemRepository::AR)
    @repository = repository
  end

  def perform(content)
    pbi = Product::BacklogItem.new(content)
    @repository.add(pbi)
    pbi.id.to_s
  end
end
