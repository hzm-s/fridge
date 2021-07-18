# typed: false
class Dao::Issue < ApplicationRecord
  has_many :criteria, -> { order :id }, class_name: 'Dao::AcceptanceCriterion', foreign_key: :dao_issue_id, dependent: :destroy
  has_one :work, class_name: 'Dao::Work', foreign_key: :dao_issue_id, dependent: :destroy

  def write(issue)
    self.attributes = {
      dao_product_id: issue.product_id.to_s,
      issue_type: issue.type.to_s,
      status: issue.status.to_s,
      description: issue.description.to_s,
      size: issue.size.to_i,
    }

    self.criteria.clear
    issue.acceptance_criteria.to_a.each do |ac|
      self.criteria.build(
        number: ac.number,
        content: ac.content,
        satisfied: ac.satisfied?
      )
    end
  end

  def read
    Issue::Issue.from_repository(
      read_issue_id,
      read_product_id,
      read_type,
      read_status,
      read_description,
      read_story_point,
      read_acceptance_criteria
    )
  end

  def read_issue_id
    Issue::Id.from_string(id)
  end

  def read_product_id
    Product::Id.from_string(dao_product_id)
  end

  def read_type
    Issue::Types.from_string(issue_type)
  end

  def read_status
    Issue::Statuses.from_string(status)
  end

  def read_description
    Issue::Description.new(description)
  end

  def read_story_point
    Issue::StoryPoint.new(size)
  end

  def read_acceptance_criteria
    criteria
      .map { |c| Issue::AcceptanceCriterion.from_repository(c.number, c.content) }
      .then { |criteria| Issue::AcceptanceCriteria.from_repository(criteria) }
  end
end
