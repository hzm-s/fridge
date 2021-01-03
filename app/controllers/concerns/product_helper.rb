# typed: false
module ProductHelper
  extend ActiveSupport::Concern

  included do
    helper_method :current_product, :current_product_team_member_role
  end

  def current_product_id
    raise 'not implemented'
  end

  def current_product
    @__current_product ||= Dao::Product.find_by(id: current_product_id)
  end

  def current_product_team
    @__current_product_team ||= fetch_product_team(current_product_id, current_user.person_id)
  end

  def current_product_team_member_role
    @__current_product_team_member_role ||= current_product_team.role(current_user.person_id.to_s)
  end

  private

  def fetch_product_team(product_id, person_id)
    ProductTeamQuery.call(product_id.to_s, person_id.to_s)
  end
end
