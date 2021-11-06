# typed: ignore
require_relative '../domain_support/pbi_domain_support'

module PbiSupport
  include PbiDomainSupport

  def add_pbi(product_id, description = 'DESC', type: :feature, acceptance_criteria: [], size: nil, release: nil, assign: false)
    if assign
      acceptance_criteria = %w(Criterion) if acceptance_criteria.empty?
      size ||= 3
      release ||= 1
    end

    append_release(product_id, release) if release

    pbi = perform_draft_pbi(product_id, Pbi::Types.from_string(type.to_s), description, release)

    append_acceptance_criteria(pbi, acceptance_criteria) if acceptance_criteria

    estimate_pbi(pbi.id, size) if size

    start_sprint_and_assign_pbi(product_id, pbi.id) if assign

    PbiRepository::AR.find_by_id(pbi.id)
  end

  def append_acceptance_criteria(pbi, contents)
    contents.each do |c|
      AppendAcceptanceCriterionUsecase.perform(pbi.id, s_sentence(c))
    end
  end

  def estimate_pbi(pbi_id, size)
    EstimateFeatureUsecase.perform(pbi_id, team_roles(:dev), Pbi::StoryPoint.new(size))
  end

  def remove_pbi(pbi_id)
    RemovePbiUsecase.perform(pbi_id)
  end

  def schedule_pbi(product_id, pbi_id, release)
    SchedulePbiUsecase.perform(product_id, team_roles(:po), pbi_id, release, 0)
  end

  private

  def perform_draft_pbi(product_id, type, desc_content, release_number)
    l_sentence(desc_content)
      .then { |desc| DraftPbiUsecase.perform(product_id, type, desc, release_number) }
      .then { |id| PbiRepository::AR.find_by_id(id) }
  end

  def start_sprint_and_assign_pbi(product_id, pbi_id)
    start_sprint(product_id)
  rescue Sprint::AlreadyStarted
  ensure
    assign_pbi_to_sprint(product_id, pbi_id)
  end
end

RSpec.configure do |c|
  c.include PbiSupport
end
