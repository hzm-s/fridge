# typed: false
module PblHelper
  def sortable_pbl_options(release)
    {
      controller: 'sort-pbl',
      sort_pbl_url: product_plan_path(product_id: release.product_id.to_s),
      release_id: release.id.to_s,
    }
  end
end
