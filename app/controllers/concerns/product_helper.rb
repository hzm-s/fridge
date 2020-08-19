# typed: false
module ProductHelper
  extend ActiveSupport::Concern

  included do
    helper_method :current_product, :current_team_member
  end

  def current_product_id
    raise 'not implemented'
  end

  def current_product
    Dao::Product.find_by(id: current_product_id)
  end

  def current_team_member
    Dao::TeamMember.find_by(dao_person_id: current_user.person_id.to_s, dao_product_id: current_product_id)
  end
end
