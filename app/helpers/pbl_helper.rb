# typed: false
module PblHelper
  def sortable_pbl_options(product_id)
    {
      controller: 'sort-pbl',
      sort_pbl_url: product_product_backlog_item_order_path(product_id: product_id)
    }
  end
end
