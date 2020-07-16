class Dao::ProductBacklogItem < ApplicationRecord
  has_many :criteria, class_name: 'Dao::AcceptanceCriterion', foreign_key: :dao_product_backlog_item_id, dependent: :destroy

  def product_id
    dao_product_id
  end
end
