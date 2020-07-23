# typed: strict
class Dao::Product < ApplicationRecord
  has_many :members, class_name: 'Dao::TeamMember', foreign_key: :dao_product_id, dependent: :destroy
  has_many :backlog_items, class_name: 'Dao::ProductBacklogItem', foreign_key: :dao_product_id, dependent: :destroy
  has_one :order, class_name: 'Dao::ProductBacklogOrder', foreign_key: :dao_product_id, dependent: :destroy
end
