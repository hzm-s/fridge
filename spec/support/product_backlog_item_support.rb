# typed: true
module ProductBacklogItemSupport
  def add_pbi(product_id, content = 'fridge helps scrum', acceptance_criteria: nil, size: nil)
    pbi = perform_to_add_pbi(product_id, content)

    return pbi unless acceptance_criteria
    add_acceptance_criteria(pbi, acceptance_criteria)

    return pbi unless size
    estimate_size(pbi.id, size)

    ProductBacklogItemRepository::AR.find_by_id(pbi.id)
  end

  def add_acceptance_criteria(pbi, contents_or_criteria)
    criteria = contents_or_criteria.map do |cc|
      cc.is_a?(String)? acceptance_criterion(cc) : cc
    end
    criteria.each do |ac|
      AddAcceptanceCriterionUsecase.perform(pbi.id, ac)
    end
  end

  def acceptance_criterion(content)
    Pbi::AcceptanceCriterion.new(content)
  end

  def acceptance_criteria(contents)
    contents.map { |c| acceptance_criterion(c) }
      .yield_self { |criteria| Pbi::AcceptanceCriteria.new(criteria) }
  end

  def estimate_size(pbi_id, size)
    EstimateProductBacklogItemSizeUsecase.perform(pbi_id, Pbi::StoryPoint.new(size))
  end

  def assign_pbi(pbi_id)
    AssignProductBacklogItemUsecase.perform(pbi_id)
  end

  private

  def perform_to_add_pbi(product_id, content)
    Pbi::Content.new(content)
      .yield_self { |c| AddProductBacklogItemUsecase.perform(product_id, c) }
      .yield_self { |id| ProductBacklogItemRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include ProductBacklogItemSupport
end
