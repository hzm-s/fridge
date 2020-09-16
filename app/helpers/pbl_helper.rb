# typed: false
module PblHelper
  def sortable_pbl_options(product_id, section_type, section_id)
    {
      controller: 'sort-pbl',
      sort_pbl_url: product_plan_path(product_id: product_id),
      section_type: section_type,
      section_id: section_id
    }
  end
end
