# typed: true
module PblHelper
  def sortable_pbl_options(product_id, release)
    {
      controller: 'sort-pbl',
      sort_pbl_url: product_plan_path(product_id: product_id),
      release_no: release.no,
    }
  end
end
