# typed: true
class Dao::Product < ApplicationRecord
  has_many :teams, class_name: 'Dao::Team', foreign_key: :dao_product_id, dependent: :destroy

  def product_id
    Product::Id.from_string(id)
  end

  def owner
    Person::Id.from_string(owner_id)
  end
end
