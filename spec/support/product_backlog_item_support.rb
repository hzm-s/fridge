# typed: true
require_relative '../domain_support/pbi_domain_support'

module ProductBacklogItemSupport
  include PbiDomainSupport

  def add_pbi(product_id, content = 'fridge helps scrum', acceptance_criteria: nil, size: nil, assigned: false)
    pbi = perform_to_add_pbi(product_id, content)

    return pbi unless acceptance_criteria
    add_acceptance_criteria(pbi, acceptance_criteria)

    return pbi unless size
    estimate_size(pbi.id, size)

    return pbi unless assigned
    assign_pbi(pbi.id)

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

  def estimate_size(pbi_id, size)
    EstimateProductBacklogItemSizeUsecase.perform(pbi_id, Pbi::StoryPoint.new(size))
  end

  def assign_pbi(pbi_id)
    AssignProductBacklogItemUsecase.perform(pbi_id)
  end

  def remove_pbi(pbi_id)
    RemoveProductBacklogItemUsecase.perform(pbi_id)
  end

  def add_release(product_id, title = 'Release2')
    AddReleaseUsecase.perform(product_id, title)
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
