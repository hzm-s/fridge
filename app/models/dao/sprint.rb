# typed: false
class Dao::Sprint < ApplicationRecord
  def write(sprint)
    self.attributes = {
      dao_product_id: sprint.product_id.to_s,
      number: sprint.number,
    }
  end
end
