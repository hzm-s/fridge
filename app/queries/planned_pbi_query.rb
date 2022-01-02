# typed: false
class PlannedPbiQuery
  class << self
    def call(product_id, release_number, index)
      Dao::Release
        .find_by(dao_product_id: product_id, number: release_number)
        &.items
        &.[](index)
        &.then { |item_id| Pbi::Id.from_string(item_id) }
    end
  end
end
