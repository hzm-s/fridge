# typed: true
class Dao::Product < ApplicationRecord
  belongs_to :owner_person, class_name: 'Dao::Person', foreign_key: :owner_id
  has_many :teams, class_name: 'Dao::Team', foreign_key: :dao_product_id, dependent: :destroy

  def product_id
    Product::Id.from_string(id)
  end

  def owner
    Person::Id.from_string(owner_id)
  end
end
