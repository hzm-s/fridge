# typed: false
module ProductHelper
  extend ActiveSupport::Concern

  included do
    helper_method :current_product, :current_product_team_member
  end

  def current_product_id
    raise 'not implemented'
  end

  def current_product
    @__current_product ||= Dao::Product.find_by(id: current_product_id)
  end

  def current_product_team_member(person_id)
    @__current_product_team_member ||=
      TeamMemberQuery.call(current_product.id.to_s, person_id)
  end
end
