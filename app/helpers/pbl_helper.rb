# typed: false
module PblHelper
  def sortable_pbl_options(product_id, release_name)
    {
      controller: 'sort-pbl',
      sort_pbl_url: product_plan_path(product_id),
      sort_pbl_group: release_name,
    }
  end

  def pbl_item_css_classes(item)
    "pbl-item-outer pbl-item-outer--#{item.status} pbl-item-bg--#{item.type}"
  end

  def pbl_item_criteria_css_classes(item)
    base = 'pbl-item__ac-trigger'
    return base unless item.must_have_acceptance_criteria?
    return base if item.criteria.any?

    "#{base} #{base}--empty"
  end
end
