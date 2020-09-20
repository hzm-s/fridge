# typed: false
class Dao::Release < ApplicationRecord
  has_many :items, class_name: 'Dao::ReleaseItem', foreign_key: :dao_release_id

  def write(release)
    self.attributes = {
      dao_product_id: release.product_id.to_s,
      title: release.title,
      can_remove: release.can_remove?
    }

    items.destroy(*items)
    release.items.to_a.each do |item|
      self.items.build(dao_issue_id: item)
    end
  end

  def read
    Release::Release.from_repository(
      read_release_id,
      read_product_id,
      title,
      read_items
    )
  end

  def read_release_id
    Release::Id.from_string(id)
  end

  def read_product_id
    Product::Id.from_string(dao_product_id)
  end

  def read_items
    items.map { |item| Issue::Id.from_string(item.dao_issue_id) }
      .yield_self { |list| Release::ItemList.new(list) }
  end
end
