# typed: false
class Dao::Pbi < ApplicationRecord
  has_many :criteria, -> { order :id },
    class_name: 'Dao::AcceptanceCriterion', foreign_key: :dao_pbi_id,
    dependent: :destroy, autosave: true
  has_one :sbi, class_name: 'Dao::Sbi', foreign_key: :dao_pbi_id, dependent: :destroy

  scope :as_aggregate, -> { eager_load(:criteria) }

  def write(pbi)
    self.attributes = {
      dao_product_id: pbi.product_id.to_s,
      pbi_type: pbi.type.to_s,
      status: pbi.status.to_s,
      description: pbi.description.to_s,
      size: pbi.size.to_i,
    }

    self.criteria.each(&:mark_for_destruction)
    pbi.acceptance_criteria.to_a.each do |ac|
      self.criteria.build(content: ac)
    end
  end

  def read
    Pbi::Pbi.from_repository(
      read_pbi_id,
      read_product_id,
      read_type,
      read_status,
      read_description,
      read_story_point,
      read_acceptance_criteria
    )
  end

  def read_pbi_id
    Pbi::Id.from_string(id)
  end

  def read_product_id
    Product::Id.from_string(dao_product_id)
  end

  def read_type
    Pbi::Types.from_string(pbi_type)
  end

  def read_status
    Pbi::Statuses.from_string(status)
  end

  def read_description
    Shared::LongSentence.new(description)
  end

  def read_story_point
    Pbi::StoryPoint.new(size)
  end

  def read_acceptance_criteria
    criteria
      .map { |c| Shared::ShortSentence.new(c.content) }
      .then { |list| Pbi::AcceptanceCriteria.new(list) }
  end
end
