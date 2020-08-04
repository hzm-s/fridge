# typed: strict
class Dao::ProductBacklog < ApplicationRecord
  def product_id_as_do
    Product::Id.from_string(dao_product_id)
  end

  def product_backlog_item_ids_as_do
    product_backlog_item_ids.map { |id| Pbi::Id.from_string(id) }
  end
end
