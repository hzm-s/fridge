# typed: false
require_relative '../domain_support/work_domain_support'

module WorkSupport
  def plan_task(issue_id, task_contents)
    task_contents.each do |content|
      PlanTaskUsecase.perform(issue_id, s_sentence(content))
    end
  end

  def start_task(issue_id, task_number)
    StartTaskUsecase.perform(issue_id, task_number)
  end

  def suspend_task(issue_id, task_number)
    SuspendTaskUsecase.perform(issue_id, task_number)
  end

  def complete_task(issue_id, task_number)
    CompleteTaskUsecase.perform(issue_id, task_number)
  end

  def satisfy_acceptance_criteria(issue_id, criterion_numbers)
    criterion_numbers.each do |n|
      SatisfyAcceptanceCriterionUsecase.perform(team_roles(:po), issue_id, n)
    end
  end

  def accept_work(issue)
    satisfy_acceptance_criteria(
      issue.id,
      issue.acceptance_criteria.to_a_with_number.map { |n, _| n },
    )
    AcceptWorkUsecase.perform(team_roles(:po), issue.id)
  end
end

RSpec.configure do |c|
  c.include WorkSupport
end
