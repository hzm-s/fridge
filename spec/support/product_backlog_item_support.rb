module ProductBacklogItemSupport
  def add_pbi(product_id, content = 'fridge helps scrum')
    Pbi::Content.from_string(content)
      .yield_self { |c| usecase.perform(product_id, c) }
      .yield_self { |id| ProductBacklogItemRepository::AR.find_by_id(id) }
  end

  private

  def usecase
    @_usecase ||= AddProductBacklogItemUsecase.new
  end
end

RSpec.configure do |c|
  c.include ProductBacklogItemSupport
end
