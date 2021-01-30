# typed: false
module PblHelper
  def sortable_pbl_options(product_id, release_name)
    release_id = release_name ? "release-#{release_name}" : 'pending'
    {
      controller: 'sort-pbl',
      sort_pbl_url: product_plan_path(product_id),
      sort_pbl_group: release_name,
      "test_update_#{release_id}" => 1,
    }
  end

  def pbl_item_css_classes(item)
    "pbl-item-outer pbl-item-outer--#{item.status} pbl-item-bg--#{item.type}"
  end

  def pbl_item_grip_css_classes(can_update)
    base = "pbl-item__grip js-sortable-handle"
    return base if can_update

    "#{base} pbl-item__grip--disabled"
  end

  def pbl_item_criteria_css_classes(item)
    base = 'pbl-item__ac-trigger'
    return base unless item.must_have_acceptance_criteria?
    return base if item.criteria.any?

    "#{base} #{base}--empty"
  end
end
