# typed: false
class Dao::Sprint < ApplicationRecord
  has_many :items, -> { order(:id) },
    class_name: 'Dao::AssignedPbi', foreign_key: :dao_sprint_id,
    dependent: :destroy, autosave: true

  scope :as_aggregate, -> { eager_load(:items) }

  def write(sprint)
    self.attributes = {
      dao_product_id: sprint.product_id.to_s,
      number: sprint.number,
      is_finished: sprint.finished?,
    }

    self.items.each(&:mark_for_destruction)
    sprint.items.to_a.each do |i|
      self.items.build(dao_pbi_id: i.to_s)
    end
  end

  def read
    Sprint::Sprint.from_repository(
      Sprint::Id.from_string(id),
      Product::Id.from_string(dao_product_id),
      number,
      is_finished,
      read_items,
    )
  end

  private

  def read_items
    items.map { |i| Pbi::Id.from_string(i.dao_pbi_id) }
      .then { |ids| Shared::SortableList.new(ids) }
  end
end
