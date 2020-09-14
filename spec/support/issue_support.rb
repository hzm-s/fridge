# typed: true
require_relative '../domain_support/issue_domain_support'

module IssueSupport
  include IssueDomainSupport

  def add_feature(product_id, description = 'FEATURE', acceptance_criteria: [], size: nil, release: 1, wip: false)
    feature = perform_add_issue(product_id, description)

    return feature unless acceptance_criteria
    add_acceptance_criteria(feature, acceptance_criteria)

    return feature unless size
    estimate_feature(feature.id, size)

    return feature unless wip
    start_issue_development(feature.id)

    IssueRepository::AR.find_by_id(feature.id)
  end

  def add_acceptance_criteria(issue, contents_or_criteria)
    criteria = contents_or_criteria.map do |cc|
      cc.is_a?(String)? acceptance_criterion(cc) : cc
    end
    criteria.each do |ac|
      AddAcceptanceCriterionUsecase.perform(issue.id, ac)
    end
  end

  def estimate_feature(issue_id, size)
    EstimateFeatureUsecase.perform(issue_id, Issue::StoryPoint.new(size))
  end

  def start_issue_development(issue_id)
    StartIssueDevelopmentUsecase.perform(issue_id)
  end

  def remove_issue(issue_id)
    RemoveIssueUsecase.perform(issue_id)
  end

  def add_release(product_id, title = 'Release2')
    AddReleaseUsecase.perform(product_id, title)
      .yield_self { |id| PlanRepository::AR.find_by_product_id(product_id) }
      .yield_self { |plan| plan.releases.last }
  end

  private

  def perform_add_issue(product_id, desc)
    Issue::Description.new(desc)
      .yield_self { |d| AddIssueUsecase.perform(product_id, d) }
      .yield_self { |id| IssueRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include IssueSupport
end
