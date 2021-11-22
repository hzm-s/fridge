# typed: false
module PblHelper
  PBI_TYPE_ICONS = {
    feature: 'fas fa-flag',
    task: 'fas fa-hammer',
    issue: 'fa fa-file',
  }

  def pbl_sortable_options(product_id, release_number)
    {
      controller: 'sort-list',
      sort_list_url: product_plan_path(product_id),
      sort_list_group: release_number,
      "test_update_items_in_release_#{release_number}" => 1,
    }
  end

  def pbl_item_css_classes(item)
    "pbl-item-outer pbl-item-outer--#{item.status}"
  end

  def pbl_item_grip_css_classes(can_update)
    base = "pbl-item__grip js-sortable-handle"
    return base if can_update

    "#{base} pbl-item__grip--disabled"
  end

  def pbl_item_type_icon(pbi_type)
    "<i class='#{PBI_TYPE_ICONS[pbi_type.to_s.to_sym]}'></i>".html_safe
  end

  def pbl_item_criteria_css_classes(item)
    base = 'pbl-item__ac-trigger'
    return base if item.criteria.any?

    "#{base} #{base}--empty"
  end
end
