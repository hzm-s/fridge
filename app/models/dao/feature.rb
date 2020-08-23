# typed: false
class Dao::Feature < ApplicationRecord
  has_many :criteria, class_name: 'Dao::AcceptanceCriterion', foreign_key: :dao_feature_id, dependent: :destroy

  def product_id
    dao_product_id
  end

  def feature_id_as_do
    Feature::Id.from_string(id)
  end

  def product_id_as_do
    Product::Id.from_string(dao_product_id)
  end

  def status_as_do
    Feature::Statuses.from_string(status)
  end

  def description_as_do
    Feature::Description.new(description)
  end

  def story_point_as_do
    Feature::StoryPoint.new(size)
  end

  def acceptance_criteria_as_do
    criteria
      .map { |c| Feature::AcceptanceCriterion.new(c.content) }
      .yield_self { |criteria| Feature::AcceptanceCriteria.new(criteria) }
  end
end
