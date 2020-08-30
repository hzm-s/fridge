# typed: true
require_relative '../domain_support/pbi_domain_support'

module PbiSupport
  include PbiDomainSupport

  def add_pbi(product_id, description = 'fridge helps scrum', acceptance_criteria: [], size: nil, wip: false)
    pbi = perform_add_pbi(product_id, description)

    return pbi unless acceptance_criteria
    add_acceptance_criteria(pbi, acceptance_criteria)

    return pbi unless size
    estimate_pbi(pbi.id, size)

    return pbi unless wip
    start_pbi_development(pbi.id)

    PbiRepository::AR.find_by_id(pbi.id)
  end

  def add_acceptance_criteria(pbi, contents_or_criteria)
    criteria = contents_or_criteria.map do |cc|
      cc.is_a?(String)? acceptance_criterion(cc) : cc
    end
    criteria.each do |ac|
      AddAcceptanceCriterionUsecase.perform(pbi.id, ac)
    end
  end

  def estimate_pbi(pbi_id, size)
    EstimatePbiUsecase.perform(pbi_id, Pbi::StoryPoint.new(size))
  end

  def start_pbi_development(pbi_id)
    StartPbiDevelopmentUsecase.perform(pbi_id)
  end

  def remove_pbi(pbi_id)
    RemovePbiUsecase.perform(pbi_id)
  end

  def add_release(product_id, title = 'Release2')
    AddReleaseUsecase.perform(product_id, title)
      .yield_self { |id| PlanRepository::AR.find_by_product_id(product_id) }
      .yield_self { |plan| plan.last_release }
  end

  private

  def perform_add_pbi(product_id, desc)
    Pbi::Description.new(desc)
      .yield_self { |d| AddPbiUsecase.perform(product_id, d) }
      .yield_self { |id| PbiRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include PbiSupport
end
