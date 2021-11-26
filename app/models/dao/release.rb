# typed: false
class Dao::Release < ApplicationRecord
  class << self
    def read(daos)
      Plan::Plan.from_repository(
        daos.first.read_product_id,
        daos.map(&:read)
      )
    end

    def sync(product_id, numbers)
      stored = where(dao_product_id: product_id).pluck(:number)
      where(dao_product_id: product_id, number: stored - numbers).destroy_all
    end
  end

  def write(release)
    self.title = release.title
    self.items = release.items.to_a.map(&:to_s)
  end

  def read_product_id
    Product::Id.from_string(dao_product_id)
  end

  def read
    Plan::Release.from_repository(
      number.to_i,
      Shared::Name.new(title),
      items.map { |i| Pbi::Id.from_string(i) }.then { |l| Shared::SortableList.new(l) }
    )
  end
end
