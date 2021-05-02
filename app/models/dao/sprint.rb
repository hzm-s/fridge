# typed: false
class Dao::Sprint < ApplicationRecord
  def write(sprint)
    self.attributes = {
      dao_product_id: sprint.product_id.to_s,
      number: sprint.number,
      is_finished: sprint.finished?,
    }
  end

  def read
    Sprint::Sprint.from_repository(
      Sprint::Id.from_string(id),
      Product::Id.from_string(dao_product_id),
      number,
      is_finished,
    )
  end
end
