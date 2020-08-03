# typed: true
module PblHelper
  STATUS_FILTER_CLASSES_BASE = 'pbl__filter btn'.freeze

  def pbl_status_filter_classes(current:, filter:)
    "#{STATUS_FILTER_CLASSES_BASE} btn-#{current == filter ? '' : 'outline-'}secondary"
  end

  def sortable_pbl_options(product_id)
    {
      controller: 'sort-pbl',
      sort_pbl_handle: '.pbl-item__grip',
      sort_pbl_url: product_product_backlog_item_order_path(product_id: product_id)
    }
  end
end
