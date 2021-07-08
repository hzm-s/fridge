# typed: false
require_relative '../domain_support/issue_domain_support'

module IssueSupport
  include IssueDomainSupport

  def plan_issue(product_id, description = 'DESC', type: :feature, acceptance_criteria: [], size: nil, release: nil)
    append_release(product_id, release) if release

    issue = perform_plan_issue(product_id, Issue::Types.from_string(type.to_s), description, release)

    append_acceptance_criteria(issue, acceptance_criteria) if acceptance_criteria

    estimate_feature(issue.id, size) if size

    IssueRepository::AR.find_by_id(issue.id)
  end

  def append_acceptance_criteria(issue, contents)
    contents.each do |c|
      AppendAcceptanceCriterionUsecase.perform(issue.id, c)
    end
  end

  def estimate_feature(issue_id, size)
    EstimateFeatureUsecase.perform(issue_id, team_roles(:dev), Issue::StoryPoint.new(size))
  end

  def remove_issue(issue_id)
    RemoveIssueUsecase.perform(issue_id)
  end

  def schedule_issue(product_id, issue_id, release)
    ScheduleIssueUsecase.perform(product_id, team_roles(:po), issue_id, release, 0)
  end

  private

  def perform_plan_issue(product_id, type, desc, release_number)
    Issue::Description.new(desc)
      .then { |d| PlanIssueUsecase.perform(product_id, type, d, release_number) }
      .then { |id| IssueRepository::AR.find_by_id(id) }
  end
end

RSpec.configure do |c|
  c.include IssueSupport
end
