class Dao::Plan < ApplicationRecord
  has_many :scopes, -> { order :id }, class_name: 'Dao::Scope', foreign_key: :dao_plan_id, dependent: :destroy

  def read
    Plan::Plan.from_repository(
      read_product_id,
      read_order,
    )
  end

  def write(plan)
    self.attributes = {
      order: plan.order.to_a.map(&:to_s)
    }

    self.scopes.clear
    plan.scopes.to_a.each do |s|
      self.scopes.build(release_id: s.release_id.to_s, tail: s.tail.to_s)
    end
  end

  private

  def read_product_id
    Product::Id.from_string(dao_product_id)
  end

  def read_order
    order
      .map { |e| Issue::Id.from_string(e) }
      .then { |ids| Plan::Order.new(ids) }
  end
end
