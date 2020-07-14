module ProductBacklogItemSupport
  def add_pbi(product_id, content = 'fridge helps scrum')
    Pbi::Content.from_string(content)
      .yield_self { |c| AddProductBacklogItemUsecase.perform(product_id, c) }
      .yield_self { |id| ProductBacklogItemRepository::AR.find_by_id(id) }
  end

  def add_acceptance_criteria(pbi, contents)
    contents.each do |content|
      AddAcceptanceCriterionUsecase.new.perform(pbi.id, content)
    end
  end
end

RSpec.configure do |c|
  c.include ProductBacklogItemSupport
end
