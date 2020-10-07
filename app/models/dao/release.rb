# typed: false
class Dao::Release < ApplicationRecord
  def write(release)
    self.attributes = {
      dao_product_id: release.product_id.to_s,
      title: release.title
    }
  end

  def read
    Release::Release.from_repository(
      read_release_id,
      read_product_id,
      title
    )
  end

  def read_release_id
    Release::Id.from_string(id)
  end

  def read_product_id
    Product::Id.from_string(dao_product_id)
  end
end
