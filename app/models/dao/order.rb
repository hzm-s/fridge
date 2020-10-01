class Dao::Order < ApplicationRecord
  def write(order)
    self.attributes = {
      entries: order.issues.to_a.map(&:to_s)
    }
  end
end
