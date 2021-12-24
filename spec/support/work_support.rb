# typed: false
require_relative '../domain_support/work_domain_support'

module WorkSupport
  def plan_task(pbi_id, task_contents)
    task_contents.each do |content|
      PlanTaskUsecase.perform(pbi_id, s_sentence(content))
    end
  end

  def start_task(pbi_id, task_number)
    StartTaskUsecase.perform(pbi_id, task_number)
  end

  def suspend_task(pbi_id, task_number)
    SuspendTaskUsecase.perform(pbi_id, task_number)
  end

  def complete_task(pbi_id, task_number)
    CompleteTaskUsecase.perform(pbi_id, task_number)
  end

  def satisfy_acceptance_criteria(pbi_id, criterion_numbers)
    criterion_numbers.each do |n|
      SatisfyAcceptanceCriterionUsecase.perform(team_roles(:po), pbi_id, n)
    end
  end

  def accept_work(pbi)
    satisfy_acceptance_criteria(
      pbi.id,
      pbi.acceptance_criteria.to_a_with_number.map { |n, _| n },
    )
    AcceptWorkUsecase.perform(team_roles(:po), pbi.id)
  end
end

RSpec.configure do |c|
  c.include WorkSupport
end
