# typed: ignore
require_relative '../domain_support/issue_domain_support'

module IssueSupport
  include IssueDomainSupport

  def plan_issue(product_id, description = 'DESC', type: :feature, acceptance_criteria: [], size: nil, release: nil, assign: false)
    if assign
      acceptance_criteria = %w(Criterion) if acceptance_criteria.empty?
      size ||= 3
      release ||= 1
    end

    append_release(product_id, release) if release

    issue = perform_plan_issue(product_id, Issue::Types.from_string(type.to_s), description, release)

    append_acceptance_criteria(issue, acceptance_criteria) if acceptance_criteria

    estimate_feature(issue.id, size) if size

    start_sprint_and_assign_issue(product_id, issue.id) if assign

    IssueRepository::AR.find_by_id(issue.id)
  end

  def append_acceptance_criteria(issue, contents)
    contents.each do |c|
      AppendAcceptanceCriterionUsecase.perform(issue.id, s_sentence(c))
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

  def satisfy_acceptance_criteria(issue_id, criterion_numbers)
    criterion_numbers.each do |n|
      SatisfyAcceptanceCriterionUsecase.perform(team_roles(:po), issue_id, n)
    end
  end

  def accept_issue(issue)
    satisfy_acceptance_criteria(
      issue.id,
      issue.acceptance_criteria.to_a.map(&:number)
    )
    AcceptIssueUsecase.perform(team_roles(:po), issue.id)
  end

  private

  def perform_plan_issue(product_id, type, desc, release_number)
    l_sentence(desc)
      .then { |d| PlanIssueUsecase.perform(product_id, type, d, release_number) }
      .then { |id| IssueRepository::AR.find_by_id(id) }
  end

  def start_sprint_and_assign_issue(product_id, issue_id)
    start_sprint(product_id)
  rescue Sprint::AlreadyStarted
  ensure
    assign_issue_to_sprint(product_id, issue_id)
  end
end

RSpec.configure do |c|
  c.include IssueSupport
end
