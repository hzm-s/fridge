# typed: false
class Dao::ProductBacklogItem < ApplicationRecord
  has_many :criteria, class_name: 'Dao::AcceptanceCriterion', foreign_key: :dao_product_backlog_item_id, dependent: :destroy

  def product_id
    dao_product_id
  end

  def pbi_id_as_do
    Pbi::Id.from_string(id)
  end

  def product_id_as_do
    Product::Id.from_string(dao_product_id)
  end

  def status_as_do
    Pbi::Statuses.from_string(status)
  end

  def content_as_do
    Pbi::Content.new(content)
  end

  def story_point_as_do
    Pbi::StoryPoint.new(size)
  end

  def acceptance_criteria_as_do
    criteria
      .map { |c| Pbi::AcceptanceCriterion.new(c.content) }
      .yield_self { |criteria| Pbi::AcceptanceCriteria.new(criteria) }
  end
end
