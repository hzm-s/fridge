# typed: true
require_relative '../domain_support/issue_domain_support'

module IssueSupport
  include IssueDomainSupport

  def add_issue(product_id, description = 'DESC', type: :feature, acceptance_criteria: [], size: nil, release: nil)
    issue = perform_add_issue(product_id, Issue::Types.from_string(type.to_s), description)

    append_acceptance_criteria(issue, acceptance_criteria) if acceptance_criteria

    estimate_feature(issue.id, size) if size

    schedule_issue(product_id, issue.id, release) if release

    IssueRepository::AR.find_by_id(issue.id)
  end
  alias_method :add_feature, :add_issue

  def append_acceptance_criteria(issue, contents_or_criteria)
    criteria = contents_or_criteria.map do |cc|
      cc.is_a?(String)? acceptance_criterion(cc) : cc
    end
    criteria.each do |ac|
      AppendAcceptanceCriterionUsecase.perform(issue.id, ac)
    end
  end

  def estimate_feature(issue_id, size)
    EstimateFeatureUsecase.perform(issue_id, Issue::StoryPoint.new(size))
  end

  def remove_issue(issue_id)
    RemoveIssueUsecase.perform(issue_id)
  end

  def schedule_issue(product_id, issue_id, release)
    ScheduleIssueUsecase.perform(product_id, issue_id, release, 0)
  end

  private

  def perform_add_issue(product_id, type, desc)
    Issue::Description.new(desc)
      .yield_self { |d| AppendIssueUsecase.perform(product_id, type, d) }
      .yield_self { |id| IssueRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include IssueSupport
end
