# typed: true
class Dao::Product < ApplicationRecord
  has_many :developments, class_name: 'Dao::Development', foreign_key: :dao_product_id, dependent: :destroy

  def product_id_as_do
    Product::Id.from_string(id)
  end

  def teams_as_do
    developments.map { |d| Team::Id.from_string(d.dao_team_id) }
  end
end
