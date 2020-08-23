# typed: false
class Dao::ProductBacklog < ApplicationRecord
  def product_id_as_do
    Product::Id.from_string(dao_product_id)
  end

  def items_as_do
    items.map { |item| Feature::Id.from_string(item) }
  end
end
