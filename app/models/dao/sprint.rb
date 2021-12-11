# typed: false
class Dao::Sprint < ApplicationRecord
  def write(sprint)
    self.attributes = {
      dao_product_id: sprint.product_id.to_s,
      number: sprint.number,
      is_finished: sprint.finished?,
      items: sprint.items.to_a.map(&:to_s)
    }
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
    items.map { |i| Pbi::Id.from_string(i) }
      .then { |ids| Shared::SortableList.new(ids) }
  end
end
