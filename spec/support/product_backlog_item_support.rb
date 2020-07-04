module ProductBacklogItemSupport
  def add_pbi(product_id, _content)
    content = Pbi::Content.from_string(_content)
    usecase.perform(product_id, content)
  end

  private

  def usecase
    @_usecase ||= AddProductBacklogItemUsecase.new
  end
end

RSpec.configure do |c|
  c.include ProductBacklogItemSupport
end
