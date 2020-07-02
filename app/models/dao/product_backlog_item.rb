class Dao::ProductBacklogItem < ApplicationRecord
  has_one :priority, class_name: 'Dao::ProductBacklogItemPriority', foreign_key: 'dao_product_backlog_item_id'
end
