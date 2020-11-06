class Dao::Plan < ApplicationRecord
  def read
    Plan::Plan.from_repository(
      read_product_id,
      read_issue_list,
    )
  end

  def write(plan)
    self.attributes = {
      entries: plan.order.to_a.map(&:to_s)
    }
  end

  private

  def read_product_id
    Product::Id.from_string(dao_product_id)
  end

  def read_issue_list
    entries
      .map { |e| Issue::Id.from_string(e) }
      .then { |ids| Plan::Order.new(ids) }
  end
end
